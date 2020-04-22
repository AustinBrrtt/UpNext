//
//  CoreDataMock.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import CoreData
import XCTest
@testable import Up_Next

class CoreDataTestCase: UpNextTestCase {
    
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        super.setUp()
    }

    func constructDomain(name: String? = nil, queue: [DomainItem] = [], backlog: [DomainItem] = []) -> Domain {
        let domain = Domain(context: managedObjectContext)
        domain.name = name
        
        for (index, item) in queue.enumerated() {
            item.inQueueOf = domain
            item.sortIndex = Int16(index)
        }
        
        for (index, item) in backlog.enumerated() {
            item.inBacklogOf = domain
            item.sortIndex = Int16(index)
        }
        
        return domain
    }

    func constructDomainItem(name: String? = nil) -> DomainItem {
        let domainItem = DomainItem(context: managedObjectContext)
        
        domainItem.name = name
        
        return domainItem
    }
}
