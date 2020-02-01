//
//  BacklogUITests.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/29/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class BacklogUITests: BaseUITests {
    
    var backlogSegment: XCUIElement {
        app.buttons["Backlog"]
    }
    
    var queueSegment: XCUIElement {
        app.buttons["Up Next"]
    }

    // Adds items to queue and backlog, ends in backlog
    override func setUp() {
        super.setUp()
        
        // Navigate into test domain
        app.tables.buttons[testDomainTitle].firstMatch.tap()
        
        // Add items to the queue
        addItem("QA")
        addItem("QB")
        
        // Switch to backlog
        backlogSegment.tap()
        
        // Add items to the backlog
        addItem("BA")
        addItem("BB")
    }
    
    // Go back to main view for final teardown
    override func tearDown() {
        goBack()
        super.tearDown()
    }
    
    // #170438798 - I want to see the backlog
    func testViewBacklog() {
        // Go to queue
        queueSegment.tap()
        
        // Check backlog segment exists and tap on it
        XCTAssert(backlogSegment.exists)
        backlogSegment.tap()
        
        // Check for lack of queue element and presence backlog element to confirm we are there.
        XCTAssertFalse(getItem("QA").exists)
        XCTAssert(getItem("BA").exists)
    }
    
    // #170438808 - I want to add items to the backlog
    func testAddItemsToBacklog() {
        // Add an item
        addItem("BC")
        
        // Check that the item is there
        XCTAssert(getItem("BC").exists)
        
        // Restart the app
        app.terminate()
        app.launch()
        getDomain(testDomainTitle).tap()
        backlogSegment.tap()
        
        // Check that the item is still there
        XCTAssert(getItem("BC").exists)
    }
    
    private func goBack() {
        let back = app.navigationBars.buttons["Domains"]
        if (back.exists) {
            back.tap()
        }
    }
}
