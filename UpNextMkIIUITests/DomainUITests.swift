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
        XCTAssert(getDomain(testDomainTitle).exists)
    }
    
    // #170967099 - I want to delete Lists
    func testDeleteLists() {
        deleteTestingDomain()
        XCTAssertFalse(getDomain(testDomainTitle).exists)
    }
    
    // #170374984 - I want my lists to persist between sessions
    func testPersistLists() {
        app.terminate()
        app.launch()
        XCTAssert(getDomain(testDomainTitle).exists)
    }
    
    // #170863851 - I want to rename Domains
    func testRenameDomains() {
        // Enter Domain View
        getDomain(testDomainTitle).tap()
        
        // Tap Edit
        let navigationBar = getNavigationBar()
        navigationBar.buttons["Edit"].tap()
        
        // Tap the title and type
        let title = app.textFields["Title"]
        title.tap()
        title.clearText()
        let newTitle = "New Title Test"
        title.typeText(newTitle)
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts[newTitle].soonExists())
        
        // Go back to list of Domains
        navigationBar.buttons["Domains"].tap()
        
        // Check for updated title in Domain List
        XCTAssert(app.buttons[newTitle].soonExists())
        
        // Clean up modified title
        deleteDomain(newTitle)
    }
}

