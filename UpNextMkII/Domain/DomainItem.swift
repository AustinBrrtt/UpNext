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
    @NSManaged public var completed: Bool
    @NSManaged public var sortIndex: Int16
    
    @NSManaged public var inQueueOf: Domain?
    @NSManaged public var inBacklogOf: Domain?
    
    public var displayName: String {
        name ?? "Untitled"
    }
    
    public var domain: Domain {
        inQueueOf ?? inBacklogOf! // We should never have an item in neither the queue nor the backlog
    }
    
    public var isInQueue: Bool {
        inQueueOf != nil
    }
    
    static func create(context: NSManagedObjectContext, name: String) -> DomainItem {
        let domainItem = DomainItem(context: context)
        domainItem.name = name
        domainItem.completed = false
        
        return domainItem
    }
}

extension DomainItem: Comparable {
    static func < (lhs: DomainItem, rhs: DomainItem) -> Bool {
        lhs.sortIndex < rhs.sortIndex
    }
}
