//
//  DomainTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNextMkII

class DomainTests: XCTestCase {
    // Returns name if it is not nil, otherwise "Untitled"
    func testDisplayName() {
        let testDomainFoo = construct(name: "Foo")
        XCTAssert(testDomainFoo.displayName == "Foo")
        
        let testDomainNil = construct()
        XCTAssert(testDomainNil.displayName == "Untitled")
    }
    
    private func construct(name: String? = nil, queue: [DomainItem] = [], backlog: [DomainItem] = []) -> Domain {
        let domain = Domain(context: createManagedObjectContext())
        
        domain.name = name
        domain.queue = Set(queue)
        domain.backlog = Set(backlog)
        
        return domain
    }
}
