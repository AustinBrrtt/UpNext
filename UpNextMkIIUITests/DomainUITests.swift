//
//  DomainUITests.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/28/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class DomainUITests: BaseUITests {

    // #170375016 - I want to create Lists
    func testCreateLists() {
        XCTAssert(app.tables.buttons["Domain Test"].exists)
    }
    
    // #170967099 - I want to delete Lists
    func testDeleteLists() {
        deleteTestingDomain()
        XCTAssertFalse(app.tables.buttons["Domain Test"].exists)
    }
    
    // #170374984 - I want my lists to persist between sessions
    func testPersistLists() {
        app.launch()
        XCTAssert(app.tables.buttons["Domain Test"].exists)
    }
}

