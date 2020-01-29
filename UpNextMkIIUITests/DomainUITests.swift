//
//  DomainUITests.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/28/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class DomainUITests: XCTestCase {
    
    var app: XCUIApplication!

    // Launches the app and creates the test domain "Domain Test"
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        clearAllTestingDomains() // Clean up in case any previous tests were stopped prematurely
        createTestingDomain()
    }

    // Deletes any remaining "Domain Test" test domains
    override func tearDown() {
        clearAllTestingDomains()
    }

    // #170375016 - I want to create Lists
    func testCreateLists() {
        XCTAssert(app.tables.buttons["Domain Test"].exists)
    }
    
    // #170967099 - I want to delete Lists
    func testDeleteLists() {
        deleteTestingDomain()
        XCTAssertFalse(app.tables.buttons["Domain Test"].exists)
    }
    
    private func createTestingDomain() {
        let addDomainField = app.textFields["Add Domain"]
        let addButton = app.images["plus.circle.fill"]

        addDomainField.tap()
        addDomainField.typeCarefully("Domain Test")
        addButton.tap()
        
    }
    
    private func deleteTestingDomain() {
        let tables = app.tables
        
        let testButton = tables.buttons["Domain Test"].firstMatch
        testButton.swipeLeft()
        tables/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    // Deletes any remaining "Domain Test" test domains
    private func clearAllTestingDomains() {
        while app.tables.buttons["Domain Test"].exists {
            deleteTestingDomain()
        }
    }
}

