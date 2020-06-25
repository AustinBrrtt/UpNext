//
//  Domain.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation

class Domain: Identifiable {
    var id: UUID = UUID()
    var name: String?
    var queue: [DomainItem]
    var backlog: [DomainItem]
    
    public var displayName: String {
        name ?? "Untitled"
    }
    
    public var queueItems: [DomainItem] {
        Array(queue).sorted()
    }
    
    public var backlogItems: [DomainItem] {
        Array(backlog).sorted()
    }
    
    @available(*, deprecated)
    static func create(name: String) -> Domain {
        return Domain(name: name)
    }
    
    init(name: String?) {
        self.name = name
        queue = []
        backlog = []
    }
    
    // TODO: Decide whether items should be class vs struct
    public func prependToQueue(_ item: DomainItem) {
        updateSortIndices(for: queueItems, add: 1)
//        item.sortIndex = 0
        queue.insert(item, at: 0)
//        item.inQueueOf = self
    }
    
    public func addToQueue(_ item: DomainItem) {
//        item.sortIndex = Int16(queue.count)
        queue.append(item)
//        item.inQueueOf = self
    }
    
    public func addToBacklog(_ item: DomainItem) {
//        item.sortIndex = Int16(backlog.count)
        backlog.append(item)
//        item.inBacklogOf = self
    }
    
    // returns true if any changes are made
    public func processScheduledMoves() -> Bool {
        var found = false
        for item in backlog {
            if item.moveOnRelease, let date = item.releaseDate, date < Date() {
                found = true
//                item.inBacklogOf = nil
                prependToQueue(item)
//                item.moveOnRelease = false
            }
        }
        return found
    }
    
    private func updateSortIndices(for items: [DomainItem], add offset: Int16 = 0) {
//        for (index, item) in items.enumerated() {
//            item.sortIndex = Int16(index) + offset
//        }
    }
}
