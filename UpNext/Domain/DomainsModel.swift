//
//  DomainsModel.swift
//  UpNext
//
//  Created by Austin Barrett on 6/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation
import Combine

class DomainsModel: ObservableObject {
    @Published var domains: [Domain] = []
    let database = Database()!
    
    init() {
        self.domains = loadDomains()
    }
    
    public func getItemIndices(from type: ItemStatus, of domain: Domain, withStatus status: ItemStatus? = nil) -> AnyPublisher<[Int], Never> {
        $domains.map { domains in
            guard let domain = domains.first(where: { $0.id == domain.id }) else { return [] }
            let list = type == .unstarted ? domain.unstarted : domain.backlog
            return list.indices.filter { list[$0].status == status }
        }
        .replaceError(with: [])
        .eraseToAnyPublisher()
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
    
    public func addItem(name: String, in type: ItemStatus, of domain: Domain) {
        let item = database.createItem(name: name, with: type, of: domain.id)!
        let domainIndex = domains.firstIndex(of: domain)!
        if type == .unstarted {
            domains[domainIndex].unstarted.append(item)
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
        guard let (domainIndex, itemIndex, location) = findItem(byId: item.id) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)].remove(at: itemIndex)
        database.deleteItem(id: item.id)
    }
    
    // Attempts to replace database with new domains. If unsuccessful, will attempt to restore previous domains.
    public func replace(domains newDomains: [Domain]) {
        database.deleteEverything()
        for domain in newDomains {
            guard let _ = database.importDomain(domain: domain) else {
                print("Failed to overwrite imported domain \(domain.name), attempting to revert")
                restoreDatabase()
                return
            }
        }
        domains = loadDomains() // Allow Database to generate IDs
    }
    
    public func move(item: DomainItem, to status: ItemStatus, of domain: Domain) {
        let isMovingToBacklog = status == .backlog
        if (item.status == status) {
            return
        }
        
        let domainIndex = domains.firstIndex(of: domain)!
        let dstKeyPath = isMovingToBacklog ? \[Domain][domainIndex].backlog : \[Domain][domainIndex].unstarted
        let srcKeyPath = item.status.keyPath(forDomainIndex: domains.firstIndex(of: domain)!)
        domains[keyPath: srcKeyPath].removeAll { $0 == item }
        var newItem = item
        newItem.status = status
        newItem.sortIndex = Int64(domains[keyPath: dstKeyPath].count + 1)
        domains[keyPath: dstKeyPath].append(newItem)
        database.updateItemStatus(item.id, to: status)
    }
    
    public func reorderItems(in type: ItemStatus, of domain: Domain, src: IndexSet, dst: Int) {
        let domainIndex = domains.firstIndex(of: domain)!
        let keyPath = type == .unstarted ? \[Domain][domainIndex].unstarted : \[Domain][domainIndex].backlog
        domains[keyPath: keyPath].sort()
        domains[keyPath: keyPath].move(fromOffsets: src, toOffset: dst)
        for index in domains[keyPath: keyPath].indices {
            domains[keyPath: keyPath][index].sortIndex = Int64(index)
            print("Reordering: #\(domains[keyPath: keyPath][index].id) to index \(index)")
            database.reorderItem(domains[keyPath: keyPath][index].id, to: Int64(index))
        }
    }
    
    public func updateItemStatus(item: DomainItem, to status: ItemStatus) {
        if (status == .completed) {
            print("updating item #\(item.id) to completed")
        }
        // Should I be making this one way data flow and only update the database from here, then refetch data? Right now I'm updating the live data, which requires finding nested references.
        // Maybe if I could reload the data and then replace it by diff? Does ObservableObject handle that for me?
        guard let (domainIndex, itemIndex, location) = findItem(byId: item.id) else {
            return
        }
        var item = domains[keyPath: location.keyPath(forDomainIndex: domainIndex)][itemIndex]
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)].remove(at: itemIndex)
        item.status = status
        domains[keyPath: status.keyPath(forDomainIndex: domainIndex)].append(item)
        database.updateItemStatus(item.id, to: status)
    }
    
    public func updateItemProperties(on item: DomainItem, to properties: ItemProperties) {
        var updatedItem = item
        updatedItem.name = properties.title.trimmingCharacters(in: .whitespaces)
        updatedItem.notes = properties.notes.count > 0 ? properties.notes : nil
        updatedItem.releaseDate = properties.useDate ? properties.date : nil
        updatedItem.moveOnRelease = properties.moveOnRelease
        
        guard let (domainIndex, itemIndex, location) = findItem(byId: item.id) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)][itemIndex] = updatedItem
        database.editItem(item.id, to: updatedItem)
        
        if (item.status != properties.status) {
            updateItemStatus(item: updatedItem, to: properties.status)
        }
    }
    
    public func item(withId id: Int64) -> DomainItem? {
        guard let (domainIndex, itemIndex, location) = findItem(byId: id) else {
            return nil
        }
        
        return domains[keyPath: location.keyPath(forDomainIndex: domainIndex)][itemIndex]
    }
    
    // returns true if any changes are made
    public func processScheduledMoves(for domain: Domain) -> Bool {
        guard let domainIndex = domains.firstIndex(where: { $0.id == domain.id }) else {
            return false
        }
        
        var found = false
        for item in domains[domainIndex].backlog {
            if item.shouldBeMoved {
                found = true
                var mutableItem = item
                mutableItem.moveOnRelease = false
                domains[domainIndex].prepend(mutableItem, toQueue: true)
            }
        }
        domains[domainIndex].backlog.removeAll(where: \.shouldBeMoved)
        
        return found
    }
    
    // Attempt to replace database with current domains in case of failed overwrite
    private func restoreDatabase() {
        database.deleteEverything()
        for domain in domains {
            let _ = database.importDomain(domain: domain)
        }
    }
    
    private func nextSortIndex(for keyPath: WritableKeyPath<[Domain], [DomainItem]>) -> Int64 {
        domains[keyPath: keyPath].isEmpty ? 0 : domains[keyPath: keyPath][domains[keyPath: keyPath].count - 1].sortIndex + 1
    }
    
    // Returns (domain index, item index, unstarted or backlog) or nil if not found
    private func findItem(byId id: Int64) -> (Int, Int, ItemStatus)? {
        var itemIndex: Int? = nil
        var location: ItemStatus = .completed
        guard let domainIndex = domains.firstIndex(where: { domain in
            itemIndex = domain.unstarted.firstIndex(where: { $0.id == id })
            
            if itemIndex != nil {
                location = .unstarted
            } else {
                itemIndex = domain.backlog.firstIndex(where: { $0.id == id })
                
                if itemIndex != nil {
                    location = .backlog
                } else {
                    itemIndex = domain.started.firstIndex(where: { $0.id == id })
                    
                    if itemIndex != nil {
                        location = .started
                    } else {
                        itemIndex = domain.completed.firstIndex(where: { $0.id == id })
                    }
                }
            }
            
            return itemIndex != nil
        }) else {
            return nil
        }
        
        return (domainIndex, itemIndex!, location)
    }
}
