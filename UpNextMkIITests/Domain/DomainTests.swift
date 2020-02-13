//
//  DomainTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNextMkII

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
}


