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
    public var moveOnRelease: Bool
    public var sortIndex: Int64
    public var releaseDate: Date?
    public var seriesName: String?
    
    var displayName: String {
        if let seriesName = seriesName {
            return "\(seriesName): \(name)"
        }
        return name
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
    
    public var queued: Bool {
        return status != .backlog
    }
    
    public var hasFutureReleaseDate: Bool {
        guard let releaseDate = releaseDate else {
            return false
        }
        return Date().noon < releaseDate.noon
    }
    
    public var shouldBeMoved: Bool {
        guard let releaseDate = releaseDate else {
            return false
        }
        return moveOnRelease && releaseDate.noon <= Date().noon
    }
    
    // For Use in SwiftUI Previews
    public static func createMock(name: String = "Sample", notes: String? = nil, status: ItemStatus = .unstarted, moveOnRelease: Bool = false, sortIndex: Int64 = 0, releaseDate: Date? = nil, seriesName: String? = nil) -> DomainItem {
        return DomainItem(id: Int64.random(in: Int64.min...Int64.max), name: name, notes: notes, status: status, moveOnRelease: moveOnRelease, sortIndex: sortIndex, releaseDate: releaseDate, seriesName: seriesName)
    }
    
    init(id: Int64 = Int64.random(in: Int64.min...Int64.max), name: String, notes: String?, status: ItemStatus, moveOnRelease: Bool, sortIndex: Int64, releaseDate: Date?, seriesName: String?) {
        self.id = id
        self.name = name
        self.notes = notes
        self.status = status
        self.moveOnRelease = moveOnRelease
        self.sortIndex = sortIndex
        self.releaseDate = releaseDate
        self.seriesName = seriesName
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
