//
//  BacklogUITests.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/29/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class QueueBacklogUITests: BaseUITests {
    
    var backlogSegment: XCUIElement {
        app.buttons["Backlog"]
    }
    
    var queueSegment: XCUIElement {
        app.buttons["Up Next"]
    }

    // Adds items to queue and backlog, ends in queue
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
        
        // Switch to queue
        queueSegment.tap()
    }
    
    // Go back to main view for final teardown
    override func tearDown() {
        goBack()
        super.tearDown()
    }
    
    // #170438798 - I want to see the backlog
    func testViewBacklog() {
        // Check if backlog segment exists and tap on it
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
    
    // #170640245 - I want to reorder items in my queue/backlog
    func testReorderItems() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        
        // Check that QA is above QB
        XCTAssert(qa.isHigherThan(qb))
        
        // Tap Edit
        let navigationBar = getNavigationBar()
        navigationBar.buttons["Edit"].tap()
        
        // Check QA's drag handle exists and drag QA below QB
        let dragHandle = app.tables.children(matching: .cell).element(boundBy: 0).buttons["Reorder"]
        XCTAssert(dragHandle.exists)
        dragHandle.swipeDown()
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check that QB is above QA and the drag handle is gone
        XCTAssert(qb.isHigherThan(qa))
        XCTAssertFalse(dragHandle.exists)
        
        // Go back and re-enter domain - Quitting app instead of going back as workaround for #171037978
        restartApp()
        getDomain(testDomainTitle).tap()
        
        // Check that QB is still above QA
        XCTAssert(qb.isHigherThan(qa))
    }
    
    // #170640293 - I want to move items from my backlog to my queue and vice versa
    func testMoveItems() {
        let qa = getItem("QA")
        
        // Long press QA and choose Move To Backlog in menu
        qa.press(forDuration: 0.5)
        app.buttons["Move to Backlog"].tap()
        
        // Check that QA is gone
        XCTAssertFalse(qa.exists)
        
        // Go to backlog and check that QA appears
        backlogSegment.tap()
        XCTAssert(qa.exists)
        
        // Long press QA and choose Move To Queue in menu
        qa.press(forDuration: 0.5)
        app.buttons["Move to Queue"].tap()
        
        // Check that QA is gone
        XCTAssertFalse(qa.exists)
        
        // Go to queue and check that QA appears
        queueSegment.tap()
        XCTAssert(qa.exists)
    }
    
    private func goBack() {
        let back = app.navigationBars.buttons["Domains"]
        if (back.exists) {
            back.tap()
        }
    }
}
