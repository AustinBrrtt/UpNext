//
//  DomainItemTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/11/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNextMkII

class DomainItemTests: CoreDataTestCase {
    func testDisplayName() {
        let testDomainItemFoo = constructDomainItem(name: "Foo")
        XCTAssert(testDomainItemFoo.displayName == "Foo")
        
        let testDomainItemNil = constructDomainItem()
        XCTAssert(testDomainItemNil.displayName == "Untitled")
        
    }
    
    // Returns the domain that the item is in the queue or backlog of
    // Items assumed to belong to at least one queue or backlog
    func testDomain() {
        let testItemA = constructDomainItem(name: "a")
        let testItemB = constructDomainItem(name: "b")
        let testDomain = constructDomain(queue: [testItemA], backlog: [testItemB])
        
        XCTAssert(testItemA.domain == testDomain)
        XCTAssert(testItemB.domain == testDomain)
    }
    
    func testIsInQueue() {
        let testItemA = constructDomainItem(name: "a")
        let testItemB = constructDomainItem(name: "b")
        let _ = constructDomain(queue: [testItemA], backlog: [testItemB])
        
        XCTAssert(testItemA.isInQueue)
        XCTAssertFalse(testItemB.isInQueue)
    }
    
    // Creates a DomainItem in the provided context with the given name
    func testCreate() {
        let testItem = DomainItem.create(context: managedObjectContext, name: "test")
        
        XCTAssert(testItem.name == "test")
    }
    
    // Moves the item to the backlog of its domain if it is in the queue
    // Moves the item to the queue of its domain if it is in the backlog
    func testMove() {
        let queueItem = constructDomainItem(name: "a")
        let backlogItem = constructDomainItem(name: "b")
        let _ = constructDomain(queue: [queueItem], backlog: [backlogItem])
        
        queueItem.move(context: managedObjectContext)
        backlogItem.move(context: managedObjectContext)
        
        XCTAssertFalse(queueItem.isInQueue)
        XCTAssert(backlogItem.isInQueue)
    }
    
    // When lhs.completed == rhs.completed, returns lhs.sortIndex < rhs.sortIndex
    // Returns true if lhs is completed and rhs is not
    // Returns false if rhs is completed and lhs is not
    func testLessThanBothNotCompleted() {
        let itemA = constructDomainItem()
        let itemB = constructDomainItem()
        let itemC = constructDomainItem()
        itemA.sortIndex = 5
        itemB.sortIndex = 7
        itemC.sortIndex = 5
        
        XCTAssert(itemA < itemB)
        XCTAssertFalse(itemB < itemA)
        XCTAssertFalse(itemA < itemC)
        XCTAssertFalse(itemC < itemA)
        
        itemA.completed = true
        
        XCTAssert(itemA < itemC)
        XCTAssertFalse(itemC < itemA)
        
        itemA.sortIndex = 2
        XCTAssert(itemA < itemB)
    }
}
