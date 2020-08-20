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
    
    @available(*, deprecated, message: "Use name")
    public var displayName: String {
        name
    }
    
    @available(*, deprecated, message: "Use init with all parameters")
    init(name: String) {
        self.id = Int64.random(in: Int64.min...Int64.max)
        self.name = name
        unstarted = []
        started = []
        completed = []
        backlog = []
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
    
    // returns true if any changes are made
    public mutating func processScheduledMoves() -> Bool {
        var found = false
        for index in backlog.indices {
            var item = backlog[index]
            if item.moveOnRelease, let date = item.releaseDate, date < Date() {
                found = true
                item.moveOnRelease = false
                prepend(item, toQueue: true)
                backlog.remove(at: index)
            }
        }
        return found
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
    static func ==(lhs: Domain, rhs: Domain) -> Bool {
        return lhs.id == rhs.id
    }
}
