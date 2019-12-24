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
    
    @NSManaged public var inQueueOf: Domain?
    @NSManaged public var inBacklogOf: Domain?
}
