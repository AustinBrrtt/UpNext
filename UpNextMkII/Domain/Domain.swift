//
//  Domain.swift
//  UpNext
//
//  Created by Austin Barrett on 12/21/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import Foundation
import CoreData

@objc(Domain)
class Domain: NSManagedObject, Identifiable {
    @NSManaged var name: String?
    
    @NSManaged var queue: Set<DomainItem>
    @NSManaged var backlog: Set<DomainItem>
    
    public var displayName: String {
        name ?? "Untitled"
    }
    
    public var queueItems: [DomainItem] {
        Array(queue).sorted()
    }
    
    public var backlogItems: [DomainItem] {
        Array(backlog).sorted()
    }
    
    static func getAll() -> NSFetchRequest<Domain> {
        let request: NSFetchRequest<Domain> = NSFetchRequest<Domain>(entityName: "Domain")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func create(context: NSManagedObjectContext, name: String) -> Domain {
        let domain = Domain(context: context)
        domain.queue = Set<DomainItem>()
        domain.backlog = Set<DomainItem>()
        domain.name = name
        
        return domain
    }
    
    public func addToQueue(_ item: DomainItem) {
        item.sortIndex = Int16(queue.count)
        queue.insert(item)
        item.inQueueOf = self
    }
    
    public func addToBacklog(_ item: DomainItem) {
        item.sortIndex = Int16(backlog.count)
        backlog.insert(item)
        item.inBacklogOf = self
    }
}
