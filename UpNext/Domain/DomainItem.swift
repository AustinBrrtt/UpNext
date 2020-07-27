//
//  Item.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation

struct DomainItem: Identifiable {
    public var id: Int64
    public var name: String
    public var notes: String?
    public var status: ItemStatus
    public var queued: Bool
    @available(*, deprecated, message: "Feature to be removed soon") public var isRepeat: Bool
    public var moveOnRelease: Bool
    public var sortIndex: Int64
    public var releaseDate: Date?
    
    @available(*, deprecated, message: "Use name")
    public var displayName: String {
        name
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
    
    public var hasReleaseDate: Bool {
        return releaseDate != nil
    }
    
    public var hasFutureReleaseDate: Bool {
        guard let releaseDate = releaseDate else {
            return false
        }
        return Date().noon < releaseDate.noon
    }
    
    @available(*, deprecated, message: "Use init with all parameters")
    init(name: String) {
        self.id = Int64.random(in: Int64.min...Int64.max)
        self.name = name
        self.notes = nil
        self.status = .unstarted
        self.queued = false
        self.isRepeat = false
        self.moveOnRelease = false
        self.sortIndex = 0
        self.releaseDate = nil
    }
    
    init(id: Int64 = Int64.random(in: Int64.min...Int64.max), name: String, notes: String?, status: ItemStatus, queued: Bool, moveOnRelease: Bool, sortIndex: Int64, releaseDate: Date?) {
        self.id = id
        self.name = name
        self.notes = notes
        self.status = status
        self.queued = queued
        self.isRepeat = false
        self.moveOnRelease = moveOnRelease
        self.sortIndex = sortIndex
        self.releaseDate = releaseDate
    }
}


extension DomainItem: Equatable, Comparable {
    static func == (lhs: DomainItem, rhs: DomainItem) -> Bool {
        // return lhs.status == rhs.status && lhs.sortIndex == rhs.sortIndex // TODO: Should == be identity, equality, or sort equality?
        return lhs.id == rhs.id
    }
    
    // Sorts by status and then by sortIndex within each status
    static func < (lhs: DomainItem, rhs: DomainItem) -> Bool {
        return lhs.status == rhs.status ? lhs.sortIndex < rhs.sortIndex : lhs.status > rhs.status
    }
}
