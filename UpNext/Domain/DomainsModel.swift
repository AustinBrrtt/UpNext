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
    
    init() {
        self.domains = loadDomains()
    }
    
    public func loadDomains() -> [Domain] {
        // TODO: Load domains
        var domains = [
            Domain(name: "Games"),
            Domain(name: "Anime")
        ]
        
        domains[0].queue = [
            DomainItem(name: "Hitman 2"),
            DomainItem(name: "The Legend of Zelda")
        ]
        domains[0].backlog = [
            DomainItem(name: "Hitman 3"),
            DomainItem(name: "Metro: Exodus")
        ]
        
        domains[1].queue = [
            DomainItem(name: "My Hero Academia"),
            DomainItem(name: "Jojo's Bizarre Adventure")
        ]
        domains[1].backlog = [
            DomainItem(name: "Attack on Titan"),
            DomainItem(name: "King of the Hill")
        ]
        
        return domains
    }
    
    public func delete(_ domain: Domain) {
        domains.removeAll { $0 == domain }
    }
    
    public func delete(_ item: DomainItem) {
        guard let (domainIndex, itemIndex, location) = findItem(item) else {
            return
        }
        
        domains[keyPath: location.keyPath(forDomainIndex: domainIndex)].remove(at: itemIndex)
    }
    
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
    
    @available(*, deprecated, message: "TODO: implement a version that passes the domain")
    public func updateIndex(for item: DomainItem, to index: Int16) {
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
    
    private func nextSortIndex(for keyPath: WritableKeyPath<[Domain], [DomainItem]>) -> Int16 {
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
    
    private enum ItemListType {
        case queue
        case backlog
        
        var other: ItemListType {
            return self == .queue ? .backlog : .queue
        }
        
        func keyPath(forDomainIndex index: Int) -> WritableKeyPath<[Domain], [DomainItem]> {
            return self == .queue ? \[Domain][index].queue : \[Domain][index].backlog
        }
    }
}
