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
}


