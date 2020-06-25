//
//  Item.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation

class DomainItem: Identifiable {
    public var id: UUID = UUID()
    public var name: String?
    public var notes: String?
    public var status: ItemStatus
    public var isRepeat: Bool
    public var moveOnRelease: Bool
    public var sortIndex: Int16
    public var releaseDate: Date?
    
    public var inQueueOf: Domain?
    public var inBacklogOf: Domain?
    
    public var displayName: String {
        name ?? "Untitled"
    }
    
    public var displayNotes: String {
        notes ?? ""
    }
    
    public var displayDate: String {
        guard let releaseDate = releaseDate else {
            return "Now"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: releaseDate)
    }
    
    public var domain: Domain {
        inQueueOf ?? inBacklogOf! // We should never have an item in neither the queue nor the backlog
    }
    
    public var isInQueue: Bool {
        inQueueOf != nil
    }
    
    public var hasReleaseDate: Bool {
        return releaseDate != nil
    }
    
    public var hasFutureReleaseDate: Bool {
        guard let releaseDate = releaseDate else {
            return false
        }
        return Date().noon < releaseDate.noon
    }
    
    @available(*, deprecated)
    static func create(name: String) -> DomainItem {
        return DomainItem(name: name)
    }
    
    init(name: String?) {
        self.name = name
        self.notes = nil
        self.status = .unstarted
        self.isRepeat = false
        self.moveOnRelease = false
        self.sortIndex = 0
        self.releaseDate = nil
    }
    
    func move() {
        if isInQueue {
            let sorted = inQueueOf!.backlog.sorted()
            sortIndex = sorted.isEmpty ? 0 : sorted[sorted.count - 1].sortIndex + 1
            inBacklogOf = inQueueOf
            inQueueOf = nil
        } else {
            let sorted = inBacklogOf!.queue.sorted()
            sortIndex = sorted.isEmpty ? 0 : sorted[sorted.count - 1].sortIndex + 1
            inQueueOf = inBacklogOf
            inBacklogOf = nil
        }
    }
}


extension DomainItem: Equatable, Comparable {
    static func == (lhs: DomainItem, rhs: DomainItem) -> Bool {
        return lhs.status == rhs.status && lhs.sortIndex == rhs.sortIndex
    }
    
    // Sorts by status and then by sortIndex within each status
    static func < (lhs: DomainItem, rhs: DomainItem) -> Bool {
        return lhs.status == rhs.status ? lhs.sortIndex < rhs.sortIndex : lhs.status > rhs.status
    }
}
