//
//  DomainItemTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/11/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNext

class DomainItemTests: CoreDataTestCase {
    // Returns the name if present or Untitled
    // Appends "(again)" if item is a repeat
    // If releaseDate is present, a hyphen is appended, followed by the date in d MMMM yyy format
    // e.g. Animal Crossing: New Horizons - 20 March 2020
    func testDisplayName() {
        let testDomainItemFoo = constructDomainItem(name: "Foo")
        XCTAssert(testDomainItemFoo.displayName == "Foo")
        
        let testDomainItemNil = constructDomainItem()
        XCTAssert(testDomainItemNil.displayName == "Untitled")
        
        testDomainItemFoo.releaseDate = dateFromComponents(year: 2032, month: 4, day: 17)
        XCTAssert(testDomainItemFoo.displayName == "Foo - 17 April 2032")
        
        testDomainItemFoo.isRepeat = true
        XCTAssert(testDomainItemFoo.displayName == "Foo (again) - 17 April 2032")
    }
    
    // Returns false if release date is undefined, today, or in the past
    // Returns true if release date is in the future
    func testHasFutureReleaseDate() {
        let item = constructDomainItem()
        
        item.releaseDate = nil
        XCTAssertFalse(item.hasFutureReleaseDate)
        
        item.releaseDate = dateFromComponents(year: 2020, month: 1, day: 30)
        XCTAssertFalse(item.hasFutureReleaseDate)
        
        item.releaseDate = dateFromComponents(year: 3000, month: 1, day: 30)
        XCTAssert(item.hasFutureReleaseDate)
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
    
    // When lhs.completed == rhs.completed and lhs.started == rhs.started, returns lhs.sortIndex < rhs.sortIndex
    // Returns true if lhs is completed and rhs is not
    // Returns false if rhs is completed and lhs is not
    // Returns true if lhs is started and rhs is not started or completed
    // Returns false if rhs is started and lhs is not started or completed
    // States: Unstarted (started = false, completed = false), Started (started = true, completed = false), completed (started = any, completed = true)
    func testLessThan() {
        let subject = constructDomainItem()
        let higher = constructDomainItem()
        let same = constructDomainItem()
        let lower = constructDomainItem()
        subject.sortIndex = 5
        higher.sortIndex = 7
        same.sortIndex = 5
        lower.sortIndex = 2
        
        // Uses sortIndex < when both are unstarted
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssertFalse(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(lower < subject)
        XCTAssertFalse(subject < lower)
        
        
        subject.status = .started
        
        // Sorts started items before unstarted
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssert(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(subject < lower)
        XCTAssertFalse(lower < subject)
        
        higher.status = .started
        same.status = .started
        lower.status = .started
        
        // Uses sortIndex < when both are started
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssertFalse(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(lower < subject)
        XCTAssertFalse(subject < lower)
        
        subject.status = .completed
        
        // Sorts completed items before started
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssert(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(subject < lower)
        XCTAssertFalse(lower < subject)
        
        higher.status = .completed
        same.status = .completed
        lower.status = .completed
        
        // Uses sortIndex < when both are completed
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssertFalse(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(lower < subject)
        XCTAssertFalse(subject < lower)
        
        higher.status = .unstarted
        same.status = .unstarted
        lower.status = .unstarted
        
        // Sorts completed items before unstarted
        XCTAssert(subject < higher)
        XCTAssertFalse(higher < subject)
        
        XCTAssert(subject < same)
        XCTAssertFalse(same < subject)
        
        XCTAssert(subject < lower)
        XCTAssertFalse(lower < subject)
        
        
    }
}
