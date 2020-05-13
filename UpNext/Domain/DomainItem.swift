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
    @NSManaged public var started: Bool
    @NSManaged public var completed: Bool
    @NSManaged public var isRepeat: Bool
    @NSManaged public var moveOnRelease: Bool
    @NSManaged public var sortIndex: Int16
    @NSManaged public var releaseDate: Date?
    
    @NSManaged public var inQueueOf: Domain?
    @NSManaged public var inBacklogOf: Domain?
    
    public var displayName: String {
        var displayName = name ?? "Untitled"
        
        if isRepeat {
            displayName += " (again)"
        }
        
        if let releaseDate = releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            displayName += " - \(formatter.string(from: releaseDate))"
        }
        
        return displayName
    }
    
    public var domain: Domain {
        inQueueOf ?? inBacklogOf! // We should never have an item in neither the queue nor the backlog
    }
    
    public var isInQueue: Bool {
        inQueueOf != nil
    }
    
    public var hasFutureReleaseDate: Bool {
        guard let releaseDate = releaseDate else {
            return false
        }
        return Date().noon < releaseDate.noon
    }
    
    public var statusIsStarted: Bool {
        started && !completed
    }
    
    static func create(context: NSManagedObjectContext, name: String) -> DomainItem {
        let domainItem = DomainItem(context: context)
        domainItem.name = name
        domainItem.started = false
        domainItem.completed = false
        
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

// Sorts such that first all completed items are shown in sort order,
// then all started items are shown in sort order,
// then all unstarted items are shown in sort order
extension DomainItem: Comparable {
    static func < (lhs: DomainItem, rhs: DomainItem) -> Bool {
        if lhs.completed && !rhs.completed {
            return true
        }
        
        if !lhs.completed && rhs.completed {
            return false
        }
        
        if lhs.started && !rhs.started {
            return true
        }
        
        if !lhs.started && rhs.started {
            return false
        }
        
        return lhs.sortIndex < rhs.sortIndex
    }
}
