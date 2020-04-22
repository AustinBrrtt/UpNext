//
//  DomainTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import Up_Next

class DomainTests: CoreDataTestCase {
    // Returns name if it is not nil, otherwise "Untitled"
    func testDisplayName() {
        let testDomainFoo = constructDomain(name: "Foo")
        XCTAssert(testDomainFoo.displayName == "Foo")
        
        let testDomainNil = constructDomain()
        XCTAssert(testDomainNil.displayName == "Untitled")
    }
    
    // Returns the queue as an Array, sorted by sortIndex
    func testQueueItems() {
        let testDomain = constructDomain(queue: [
            constructDomainItem(name: "foo"),
            constructDomainItem(name: "bar"),
            constructDomainItem(name: "baz"),
            constructDomainItem(name: "bat")
        ])
        
        let queueItems = testDomain.queueItems
        
        XCTAssert(queueItems[0].name == "foo")
        XCTAssert(queueItems[1].name == "bar")
        XCTAssert(queueItems[2].name == "baz")
        XCTAssert(queueItems[3].name == "bat")
    }
    
    // Returns the backlog as an Array, sorted by sortIndex
    func testBacklogItems() {
        let testDomain = constructDomain(backlog: [
            constructDomainItem(name: "foo"),
            constructDomainItem(name: "bar"),
            constructDomainItem(name: "baz"),
            constructDomainItem(name: "bat")
        ])
        
        let backlogItems = testDomain.backlogItems
        
        XCTAssert(backlogItems[0].name == "foo")
        XCTAssert(backlogItems[1].name == "bar")
        XCTAssert(backlogItems[2].name == "baz")
        XCTAssert(backlogItems[3].name == "bat")
    }
    
    // Adds the item to the beginning of the queue
    func testPrependToQueue() {
        let testDomain = constructDomain(queue: [
            constructDomainItem(name: "foo"),
            constructDomainItem(name: "bar")
        ])
        
        let baz = constructDomainItem(name: "baz")
        
        testDomain.prependToQueue(baz)
        
        let queueItems = testDomain.queueItems
        XCTAssert(queueItems[0].name == "baz")
        XCTAssert(baz.inQueueOf == testDomain)
    }
    
    // Adds the item to the end of the queue
    func testAddToQueue() {
        let testDomain = constructDomain(queue: [
            constructDomainItem(name: "foo"),
            constructDomainItem(name: "bar")
        ])
        
        let baz = constructDomainItem(name: "baz")
        
        testDomain.addToQueue(baz)
        
        let queueItems = testDomain.queueItems
        XCTAssert(queueItems[queueItems.count - 1].name == "baz")
        XCTAssert(baz.inQueueOf == testDomain)
    }
    
    // Adds the item to the end of the backlog
    func testAddToBacklog() {
        let testDomain = constructDomain(backlog: [
            constructDomainItem(name: "foo"),
            constructDomainItem(name: "bar")
        ])
        
        let baz = constructDomainItem(name: "baz")
        
        testDomain.addToBacklog(baz)
        
        let backlogItems = testDomain.backlogItems
        XCTAssert(backlogItems[backlogItems.count - 1].name == "baz")
        XCTAssert(baz.inBacklogOf == testDomain)
    }
    
    // Returns a FetchRequest for all Domains, sorted by name (ascending)
    func testGetAll() {
        let fetchRequest = Domain.getAll()
        let sortDescriptor = fetchRequest.sortDescriptors![0]
        
        XCTAssert(fetchRequest.entityName == "Domain")
        XCTAssert(sortDescriptor.key == "name")
        XCTAssert(sortDescriptor.ascending == true)
    }
    
    // Creates a Domain in the provided context with the given name, an empty queue, and an empty backlog
    func testCreate() {
        let testDomain = Domain.create(context: managedObjectContext, name: "test")
        
        XCTAssert(testDomain.name == "test")
        XCTAssert(testDomain.queue.isEmpty)
        XCTAssert(testDomain.backlog.isEmpty)
    }
    
    // Moves any backlog items set to automatically move to queue that have passed their release dates
    // Returns true if any changes are made
    func testProcessScheduledMoves() {
        let testDomain = constructDomain()
        
        XCTAssertFalse(testDomain.processScheduledMoves())
        
        let item = constructDomainItem()
        item.releaseDate = Date()
        item.moveOnRelease = true
        testDomain.addToBacklog(item)
        
        XCTAssert(testDomain.processScheduledMoves())
        XCTAssert(testDomain.backlog.isEmpty)
        XCTAssert(testDomain.queue.first == item)
    }
}


