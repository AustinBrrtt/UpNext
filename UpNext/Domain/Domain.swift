//
//  Domain.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation

struct Domain: Identifiable {
    public var id: Int64
    public var name: String
    public var completed: [DomainItem]
    public var started: [DomainItem]
    public var unstarted: [DomainItem]
    public var backlog: [DomainItem]
    
    public var items: [DomainItem] {
        unstarted + started + completed + backlog
    }
    
    // For use in SwiftUI Previews
    public static func createMock(name: String = "Sample", unstarted: [DomainItem] = [], started: [DomainItem] = [], completed: [DomainItem] = [], backlog: [DomainItem] = []) -> Domain {
        return Domain(id: Int64.random(in: Int64.min...Int64.max), name: name, unstarted: unstarted, started: started, completed: completed, backlog: backlog)
    }
    
    init(id: Int64, name: String, unstarted: [DomainItem] = [], started: [DomainItem] = [], completed: [DomainItem] = [], backlog: [DomainItem] = []) {
        self.id = id
        self.name = name
        self.unstarted = unstarted
        self.started = started
        self.completed = completed
        self.backlog = backlog
    }
    
    public mutating func prepend(_ item: DomainItem, toQueue queue: Bool) {
        if queue {
            unstarted.insert(item, at: 0)
        } else {
            backlog.insert(item, at: 0)
        }
        updateSortIndices(for: queue ? .unstarted : .backlog)
    }
    
    public mutating func add(_ item: DomainItem, toQueue queue: Bool) {
        var mutableItem = item
        mutableItem.sortIndex = Int64((queue ? unstarted : backlog).count)
        if queue {
            unstarted.append(mutableItem)
        } else {
            backlog.append(mutableItem)
        }
    }
    
    public func item(id: Int64, status: ItemStatus) -> DomainItem? {
        switch status {
        case .backlog:
            return backlog.first { $0.id == id }
        case .unstarted:
            return unstarted.first { $0.id == id }
        case .started:
            return started.first { $0.id == id }
        case .completed:
            return completed.first { $0.id == id }
        }
    }
    
    public func hasSequel(to prequel: DomainItem) -> Bool {
        for item in unstarted + backlog + started {
            if item.seriesName == prequel.seriesName && item.id != prequel.id {
                return true
            }
        }
        
        return false
    }
    
    private mutating func updateSortIndices(for type: ItemStatus) {
        for index in (type == .unstarted ? unstarted : backlog).indices {
            if (type == .unstarted) {
                unstarted[index].sortIndex = Int64(index)
            } else {
                backlog[index].sortIndex = Int64(index)
            }
        }
    }
}

extension Domain: Equatable {
    static func ==(_ lhs: Domain, _ rhs: Domain) -> Bool {
        return propertiesEqual(lhs, rhs) && itemsEqual(lhs, rhs)
    }
    
    static func propertiesEqual(_ lhs: Domain, _ rhs: Domain) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
    
    static func itemsEqual(_ lhs: Domain, _ rhs: Domain) -> Bool {
        let lhsItems = lhs.items
        let rhsItems = rhs.items
        
        if lhsItems.count != rhsItems.count {
            return false
        }
        
        for index in lhsItems.indices {
            if lhsItems[index] != rhsItems[index] {
                return false
            }
        }
        
        return true
    }
}
