//
//  Item.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation
import CoreData

@objc(DomainItem)
class DomainItem: NSManagedObject, Identifiable {
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var rawStatus: String
    @NSManaged public var isRepeat: Bool
    @NSManaged public var moveOnRelease: Bool
    @NSManaged public var sortIndex: Int16
    @NSManaged public var releaseDate: Date?
    
    @NSManaged public var inQueueOf: Domain?
    @NSManaged public var inBacklogOf: Domain?
    
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
    
    // Temporary while converting to status enum
    public var status: ItemStatus {
        get { ItemStatus(rawValue: rawStatus)! }
        set { rawStatus = newValue.rawValue }
    }
    
    static func create(context: NSManagedObjectContext, name: String) -> DomainItem {
        let domainItem = DomainItem(context: context)
        domainItem.name = name
        
        return domainItem
    }
    
    func move(context: NSManagedObjectContext) {
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
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
    
    func readyForRelease() -> Bool {
        if let date = releaseDate {
            if date < Date() {
                releaseDate = nil
                // Logic to move to queue will go here
                return true
            }
            return false
        }
        return true
    }
}

// Sorts by status and then by sortIndex within each status
extension DomainItem: Comparable {
    static func < (lhs: DomainItem, rhs: DomainItem) -> Bool {
        return lhs.status == rhs.status ? lhs.sortIndex < rhs.sortIndex : lhs.status < rhs.status
    }
}
