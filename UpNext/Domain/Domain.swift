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
    public var queue: [DomainItem]
    public var backlog: [DomainItem]
    
    @available(*, deprecated, message: "Use name")
    public var displayName: String {
        name
    }
    
    @available(*, deprecated, message: "Use init with all parameters")
    init(name: String) {
        self.id = Int64.random(in: Int64.min...Int64.max)
        self.name = name
        queue = []
        backlog = []
    }
    
    init(id: Int64, name: String, queue: [DomainItem] = [], backlog: [DomainItem] = []) {
        self.id = id
        self.name = name
        self.queue = queue
        self.backlog = backlog
    }
    
    public mutating func prepend(_ item: DomainItem, to type: ItemListType) {
        if type == .queue {
            queue.insert(item, at: 0)
        } else {
            backlog.insert(item, at: 0)
        }
        updateSortIndices(for: type)
    }
    
    public mutating func add(_ item: DomainItem, to type: ItemListType) {
        var mutableItem = item
        mutableItem.sortIndex = Int64((type == .queue ? queue : backlog).count)
        if type == .queue {
            queue.append(mutableItem)
        } else {
            backlog.append(mutableItem)
        }
    }
    
    // returns true if any changes are made
    public mutating func processScheduledMoves() -> Bool {
        var found = false
        for index in backlog.indices {
            var item = backlog[index]
            if item.moveOnRelease, let date = item.releaseDate, date < Date() {
                found = true
                item.moveOnRelease = false
                prepend(item, to: .queue)
                backlog.remove(at: index)
            }
        }
        return found
    }
    
    private mutating func updateSortIndices(for type: ItemListType) {
        for index in (type == .queue ? queue : backlog).indices {
            if (type == .queue) {
                queue[index].sortIndex = Int64(index)
            } else {
                backlog[index].sortIndex = Int64(index)
            }
        }
    }
}

extension Domain: Equatable {
    static func ==(lhs: Domain, rhs: Domain) -> Bool {
        return lhs.id == rhs.id
    }
}
