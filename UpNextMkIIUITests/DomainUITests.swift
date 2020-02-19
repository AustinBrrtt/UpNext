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
    
    // #171034497 - I want leading/trailing whitespace to be trimmed from titles
    func testCreateListWhitespace() {
        addDomain("  domainA")
        addDomain("domainB  ")
        
        XCTAssert(getDomain("domainA").exists)
        XCTAssertFalse(getDomain("  domainA").exists)
        
        XCTAssert(getDomain("domainB").exists)
        XCTAssertFalse(getDomain("domainB  ").exists)
        
        deleteDomain("domainA")
        deleteDomain("domainB")
    }
    
    // #170967099 - I want to delete Lists
    // #170967352 - Deleted objects should remain deleted after quitting and reopening the app
    func testDeleteLists() {
        deleteTestingDomain()
        XCTAssertFalse(getDomain(testDomainTitle).exists)
        
        // Make sure it doesn't return on relaunch
        restartApp()
        XCTAssertFalse(getDomain(testDomainTitle).exists)
    }
    
    // #170374984 - I want my lists to persist between sessions
    func testPersistLists() {
        restartApp()
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
        let newTitle = "New Title Test"
        title.replaceText(newTitle)
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts[newTitle].soonExists())
        
        // Go back to list of Domains
        goBack()
        
        // Check for updated title in Domain List
        XCTAssert(app.buttons[newTitle].soonExists())
        
        // Clean up modified title
        deleteDomain(newTitle)
    }
    
    // #171034497 - I want leading/trailing whitespace to be trimmed from titles
    func testRenameDomainsWhitespace() {
        getDomain(testDomainTitle).tap()
        
        // Tap Edit
        let navigationBar = getNavigationBar()
        navigationBar.buttons["Edit"].tap()
        
        // Tap the title and type
        let title = app.textFields["Title"]
        title.replaceText("   Leading Title")
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts["Leading Title"].soonExists())
        XCTAssertFalse(app.staticTexts["   Leading Title"].soonExists())
        
        // Tap Edit
        navigationBar.buttons["Edit"].tap()
        
        // Tap the title and type
        title.replaceText("Trailing Title    ")
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts["Trailing Title"].soonExists())
        XCTAssertFalse(app.staticTexts["Trailing Title    "].soonExists())
        
        goBack()
        deleteDomain("Trailing Title")
    }
}

