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
    
    @NSManaged var queue: NSSet
    @NSManaged var backlog: NSSet
    
    static func getAll() -> NSFetchRequest<Domain> {
        let request: NSFetchRequest<Domain> = NSFetchRequest<Domain>(entityName: "Domain")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func create(context: NSManagedObjectContext, name: String) -> Domain {
        let domain = Domain(context: context)
        domain.queue = NSSet()
        domain.backlog = NSSet()
        domain.name = name
        
        return domain
    }
}
