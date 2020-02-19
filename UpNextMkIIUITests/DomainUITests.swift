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
    
    // #171346745 - I want the keyboard to dismiss when I tap the add button
    func testAddButtonDismissesKeyboard() {
        addDomain("Foo")
        
        sleep(1)
        XCTAssert(app.keyboards.count == 0)
        
        deleteDomain("Foo")
    }
    
    // #170897714 - I want the first letter of each word to automatically capitalize as I enter a domain name
    func testAutoCapitalizeCreate() {
        let textField = app.textFields["Add Domain"]
        let keys = [ "F", "o", "o", "space", "B", "a", "r" ]
        
        textField.tap()
        for key in keys {
            let key = app.keys[key]
            XCTAssertTrue(key.exists)
            key.tap()
        }
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
        sleep(1) // Make sure save happens before quit
        restartApp()
        XCTAssert(getDomain(testDomainTitle).exists)
    }
    
    // #170863851 - I want to rename Domains
    // #171034432 - I want to easily clear text in name editing/entering text fields
    func testRenameDomains() {
        // Enter Domain View
        getDomain(testDomainTitle).tap()
        
        // Tap Edit
        let navigationBar = getNavigationBar()
        navigationBar.buttons["Edit"].tap()
        
        // Tap the title and type
        let title = app.textFields["Title"]
        let newTitle = "New Title Test"
        title.tap()
        app.images.firstMatch.tap() // Tap clear button
        title.typeText(newTitle)
        
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
        app.images.firstMatch.tap() // Tap clear button
        title.tap()
        title.typeText("   Leading Title")
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts["Leading Title"].soonExists())
        XCTAssertFalse(app.staticTexts["   Leading Title"].soonExists())
        
        // Tap Edit
        navigationBar.buttons["Edit"].tap()
        
        // Tap the title and type
        app.images.firstMatch.tap() // Tap clear button
        title.tap()
        title.typeText("Trailing Title    ")
        
        // Tap Done
        navigationBar.buttons["Done"].tap()
        
        // Check for updated title in Domain View
        XCTAssert(app.staticTexts["Trailing Title"].soonExists())
        XCTAssertFalse(app.staticTexts["Trailing Title    "].soonExists())
        
        goBack()
        deleteDomain("Trailing Title")
    }
    
    // #170897714 - I want the first letter of each word to automatically capitalize as I enter a domain name
    func testAutoCapitalizeEdit() {
        getDomain(testDomainTitle).tap()
        
        // Tap Edit
        let navigationBar = getNavigationBar()
        navigationBar.buttons["Edit"].tap()
        
        // Clear the title
        let title = app.textFields["Title"]
        app.images.firstMatch.tap() // Tap clear button
        title.tap()
        
        // Type the keys
        let keys = [ "F", "o", "o", "space", "B", "a", "r" ]
        for key in keys {
            let key = app.keys[key]
            XCTAssertTrue(key.exists)
            key.tap()
        }
        
        // Reset the title for cleanup
        app.images.firstMatch.tap() // Tap clear button
        title.tap()
        title.typeText(testDomainTitle)
        navigationBar.buttons["Done"].tap()
        
        goBack()
    }
}

