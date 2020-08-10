//
//  DomainsModel.swift
//  UpNext
//
//  Created by Austin Barrett on 6/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

class DomainsModel: ObservableObject {
    @Published var domains: [Domain] = []
    let database = Database()!
    
    init() {
        self.domains = loadDomains()
    }
    
    public func loadDomains() -> [Domain] {
        guard let domains = database.load() else {
            assertionFailure("Failed to load data")
            return []
        }
        return domains
    }
    
    public func addDomain(name: String) {
        domains.append(database.createDomain(name: name)!)
    }
    
    public func addItem(name: String, in type: ItemListType, of domain: Domain) {
        let item = database.createItem(name: name, in: type, of: domain.id)!
        let domainIndex = domains.firstIndex(of: domain)!
        if type == .queue {
            domains[domainIndex].queue.append(item)
        } else {
            domains[domainIndex].backlog.append(item)
        }
    }
    
    public func renameDomain(_ domain: Domain, to name: String) {
        domains[domains.firstIndex(of: domain)!].name = name
        database.renameDomain(domain.id, to: name)
    }
    
    public func delete(_ domain: Domain) {
        domains.removeAll { $0 == domain }
        database.deleteDomain(id: domain.id)
    }
    
    public func delete(_ item: DomainItem) {
        guard let (domainIndex, itemIndex, location) = findItem(item) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)].remove(at: itemIndex)
        database.deleteItem(id: item.id)
    }
    
    public func deleteAll() {
        domains = []
        database.deleteEverything()
    }
    
    public func replace(domains newDomains: [Domain]) {
        database.deleteEverything()
        domains = newDomains
        for domain in domains {
            database.importDomain(domain: domain)
        }
    }
    
    @available(*, deprecated, message: "Call move with target and domain")
    public func move(item: DomainItem) {
        guard let (domainIndex, itemIndex, location) = findItem(item) else {
            return
        }
        
        let targetKeyPath: WritableKeyPath = location.other.keyPath(forDomainIndex: domainIndex)
        let sourceKeyPath: WritableKeyPath = location.keyPath(forDomainIndex: domainIndex)
        let sortIndex = nextSortIndex(for: targetKeyPath)
        domains[keyPath: targetKeyPath].append(item)
        domains[keyPath: targetKeyPath][domains[keyPath: targetKeyPath].count - 1].sortIndex = sortIndex
        domains[keyPath: sourceKeyPath].remove(at: itemIndex)
    }
    
    public func move(item: DomainItem, to type: ItemListType, of domain: Domain) {
        let isMovingToQueue = type == .queue
        if (item.queued == isMovingToQueue) {
            return
        }
        
        let domainIndex = domains.firstIndex(of: domain)!
        let dstKeyPath = isMovingToQueue ? \[Domain][domainIndex].queue : \[Domain][domainIndex].backlog
        let srcKeyPath = isMovingToQueue ? \[Domain][domainIndex].backlog : \[Domain][domainIndex].queue
        domains[keyPath: srcKeyPath].removeAll { $0 == item }
        var newItem = item
        newItem.queued = isMovingToQueue
        newItem.sortIndex = Int64(domains[keyPath: dstKeyPath].count + 1)
        domains[keyPath: dstKeyPath].append(newItem)
        database.moveItem(item.id, to: type)
    }
    
    public func reorderItems(in type: ItemListType, of domain: Domain, src: IndexSet, dst: Int) {
        let domainIndex = domains.firstIndex(of: domain)!
        let keyPath = type == .queue ? \[Domain][domainIndex].queue : \[Domain][domainIndex].backlog
        domains[keyPath: keyPath].sort()
        domains[keyPath: keyPath].move(fromOffsets: src, toOffset: dst)
        for index in domains[keyPath: keyPath].indices {
            domains[keyPath: keyPath][index].sortIndex = Int64(index)
            print("Reordering: #\(domains[keyPath: keyPath][index].id) to index \(index)")
            database.reorderItem(domains[keyPath: keyPath][index].id, to: Int64(index))
        }
    }
    
    public func updateItemStatus(item: DomainItem, to status: ItemStatus) {
        // Should I be making this one way data flow and only update the database from here, then refetch data? Right now I'm updating the live data, which requires finding nested references.
        // Maybe if I could reload the data and then replace it by diff? Does ObservableObject handle that for me?
        guard let (domainIndex, itemIndex, location) = findItem(item) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)][itemIndex].status = status
        database.updateItemStatus(item.id, to: status)
    }
    
    @available(*, deprecated, message: "TODO: implement a version that passes the domain")
    public func updateIndex(for item: DomainItem, to index: Int64) {
        guard let (domainIndex, itemIndex, location) = findItem(item) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)][itemIndex].sortIndex = index
    }
    
    @available(*, deprecated, message: "Get queue/backlog status from context")
    public func isItemInQueue(_ item: DomainItem) -> Bool {
        guard let (_, _, location) = findItem(item) else {
            return false
        }
        
        return location == .queue
    }
    
    private func nextSortIndex(for keyPath: WritableKeyPath<[Domain], [DomainItem]>) -> Int64 {
        domains[keyPath: keyPath].isEmpty ? 0 : domains[keyPath: keyPath][domains[keyPath: keyPath].count - 1].sortIndex + 1
    }
    
    // Returns (domain index, item index, queue or backlog) or nil if not found
    private func findItem(_ item: DomainItem) -> (Int, Int, ItemListType)? {
        var itemIndex: Int? = nil
        var location: ItemListType = .backlog
        guard let domainIndex = domains.firstIndex(where: { domain in
            itemIndex = domain.queue.firstIndex(of: item)
            
            if itemIndex != nil {
                location = .queue
            } else {
                itemIndex = domain.backlog.firstIndex(of: item)
            }
            
            return itemIndex != nil
        }) else {
            return nil
        }
        
        return (domainIndex, itemIndex!, location)
    }
}
