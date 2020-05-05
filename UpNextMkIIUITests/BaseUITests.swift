//
//  BaseUITests.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/30/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class BaseUITests: XCTestCase {
    
    let testDomainTitle = "Domain Test"
    var app: XCUIApplication!

    // Launches the app and creates the test domain
    override func setUp() {
        app = XCUIApplication()
        app.launch()
        clearAllTestingDomains() // Clean up in case any previous tests were stopped prematurely
        createTestingDomain()
    }

    // Deletes any remaining test domains
    override func tearDown() {
        clearAllTestingDomains()
    }
    
    func addItem(_ name: String) {
        let textField = app.textFields["Add Item"]
        let addButton: XCUIElement = app.images["plus.circle.fill"]
        
        textField.tap()
        textField.typeText(name)
        addButton.tap()
    }
    
    func addDomain(_ name: String) {
        let textField = app.textFields["Add Domain"]
        let addButton: XCUIElement = app.images["plus.circle.fill"]
        
        textField.tap()
        textField.typeText(name)
        addButton.tap()
    }
    
    func createTestingDomain() {
        addDomain(testDomainTitle)
    }
    
    func deleteTestingDomain() {
        deleteDomain(testDomainTitle)
    }
    
    func deleteDomain(_ name: String) {
        let domain = getDomain(name)
        domain.swipeLeft()
        app.tables.buttons["trailing0"].tap()
    }
    
    // Deletes any remaining test domains
    func clearAllTestingDomains() {
        while app.tables.buttons[testDomainTitle].exists {
            deleteTestingDomain()
        }
    }
    
    func getItem(_ name: String) -> XCUIElement {
        return app.tables.buttons[name].firstMatch
    }
    
    func getDomain(_ name: String) -> XCUIElement {
        return app.tables.buttons[name].firstMatch
    }
    
    func getNavigationBar() -> XCUIElement {
        return app.navigationBars.firstMatch
    }
    
    func restartApp() {
        app.terminate()
        app.launch()
    }
    
    func goBack() {
        let backButton = getNavigationBar().buttons.element(boundBy: 0)
        if backButton.exists {
            backButton.tap()
        }
    }
}
