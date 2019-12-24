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
    
    func addToQueue(_ item: DomainItem) {
        queue.insert(item)
        item.inQueueOf = self
    }
    
    func addToBacklog(_ item: DomainItem) {
        backlog.insert(item)
        item.inBacklogOf = self
    }
}
