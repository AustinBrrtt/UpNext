//
//  QueueUITests.swift
//  UpNextUITests
//
//  Created by Austin Barrett on 5/12/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

class QueueUITests: BaseUITests {
    
    var editItemNameField: XCUIElement {
        app.textFields["Item Title"]
    }
    
    var editItemReleaseDateField: XCUIElement {
        app.scrollViews.otherElements.datePickers["Release Date"]
    }

    // Adds items to queue and backlog, ends in queue
    override func setUp() {
        super.setUp()
        
        // Navigate into test domain
        app.tables.buttons[testDomainTitle].firstMatch.tap()
        
        // Add items to the queue
        addItem("QA")
        addItem("QB")
    }
    
    // Go back to main view for final teardown
    override func tearDown() {
        goBack()
        super.tearDown()
    }
    
    // #171346745 - I want the keyboard to dismiss when I tap the add button
    func testAddButtonDismissesKeyboard() {
        addItem("Foo")
        sleep(1)
        
        XCTAssert(app.keyboards.count == 0)
    }
    
    // #171034497 - I want leading/trailing whitespace to be trimmed from titles
    func testAddItemsWhitespace() {
        addItem("   leading")
        addItem("trailing   ")
        
        XCTAssertFalse(getItem("   leading").exists)
        XCTAssertFalse(getItem("trailing   ").exists)
        XCTAssert(getItem("leading").exists)
        XCTAssert(getItem("trailing").exists)
    }
    
    // #170897714 - I want the first letter of each word to automatically capitalize as I enter an item name
    func testAddItemsAutoCapitalize() {
        let textField = app.textFields["Add Item"]
        let addButton: XCUIElement = app.images["plus.circle.fill"]
        
        textField.tap()
        let keys = [ "F", "o", "o", "space", "B", "a", "r" ]
        for key in keys {
            let key = app.keys[key]
            XCTAssertTrue(key.exists)
            key.tap()
        }
        addButton.tap()
    }
    
    // #170640245 - I want to reorder items in my queue/backlog
    func testReorderItems() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        
        // Check that QA is above QB
        XCTAssert(qa.isHigherThan(qb))
        
        // Tap Edit
        tapNavButton("Edit")
        
        // Check QA's drag handle exists and drag QA below QB
        let dragHandle = app.tables.children(matching: .cell).element(boundBy: 0).buttons["Reorder"]
        XCTAssert(dragHandle.exists)
        dragHandle.manualSwipeDown()
        
        // Tap Done
        tapNavButton("Done")
        
        // Check that QB is above QA and the drag handle is gone
        XCTAssert(qb.isHigherThan(qa))
        XCTAssertFalse(dragHandle.exists)
        
        // Go back and re-enter domain - Quitting app instead of going back as workaround for #171037978
        // (#171037978 prevents navigation to a child view immediately after pressing back from that view - Simulator only)
        restartApp()
        getDomain(testDomainTitle).tap()
        
        // Check that QB is still above QA
        XCTAssert(qb.isHigherThan(qa))
    }
    
    // #171034497 - I want leading/trailing whitespace to be trimmed from titles
    func testEditItemsWhitespace() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        
        // Long press QA and choose Edit
        qa.longPress()
        chooseFromContextMenu("Edit")
        
        // Expect edit title field to be shown
        XCTAssert(editItemNameField.exists)
        
        // Edit title and tap "Save"
        app.images.firstMatch.tap() // Tap clear button
        editItemNameField.tap()
        editItemNameField.typeText("   leading")
        tapNavButton("Save")
        
        // Check that the leading spaces have been removed
        XCTAssertFalse(getItem("   leading").exists)
        XCTAssert(getItem("leading").exists)
        
        // Long press QB and choose Edit
        qb.longPress()
        chooseFromContextMenu("Edit")
        
        // Edit title and tap "Save"
        app.images.firstMatch.tap() // Tap clear button
        editItemNameField.tap()
        editItemNameField.typeText("trailing   ")
        tapNavButton("Save")
        
        // Check that the trailing spaces have been removed
        XCTAssert(getItem("trailing").exists)
        XCTAssertFalse(getItem("trailing   ").exists)
    }
    
    
    // #170897714 - I want the first letter of each word to automatically capitalize as I enter an item name
    func testEditItemAutoCapitalize() {
        let qa = getItem("QA")
        
        // Long press QA and choose Edit
        qa.longPress()
        chooseFromContextMenu("Edit")

        // Edit title and tap "Save"
        app.images.firstMatch.tap() // Tap clear button
        editItemNameField.tap()
        
        // Type the keys
        let keys = [ "F", "o", "o", "space", "B", "a", "r" ]
        for key in keys {
            let key = app.keys[key]
            XCTAssertTrue(key.exists)
            key.tap()
        }
        
        tapNavButton("Save")
    }
    
    // #170914920 - I want to mark items as completed
    // #171602645 - I want to mark items as in progress
    func testItemState() {
        addItem("QC")
        let qa = getItem("QA")
        let qb = getItem("QB")
        let qc = getItem("QC")
        
        toggleItemState(qb)
        toggleItemState(qc)
        
        // Items still shown
        XCTAssert(qa.exists)
        XCTAssert(qb.exists)
        XCTAssert(qc.exists)
        
        // In progress items are shown above unstarted, sort order is preserved within same status
        XCTAssert(qc.isHigherThan(qa))
        XCTAssert(qb.isHigherThan(qc))
        
        toggleItemState(qc)
        
        // Completed item is hidden
        XCTAssert(qa.exists)
        XCTAssert(qb.exists)
        XCTAssertFalse(qc.exists)
        
        toggleShowCompletedItems() // Show
        
        XCTAssert(qa.exists)
        XCTAssert(qb.exists)
        XCTAssert(qc.exists)
        
        // Completed items are shown above in progress items, which are still above unstarted items
        XCTAssert(qc.isHigherThan(qb))
        XCTAssert(qb.isHigherThan(qa))

        
        toggleShowCompletedItems() // Hide
        
        // Re-hides completed items
        XCTAssert(qa.exists)
        XCTAssert(qb.exists)
        XCTAssertFalse(qc.exists)
        
    }
    
    // Returns the string representation of the date
    private func setDatePickerValueToTodayPlus(days: Int = 0, months: Int = 0, years: Int = 0) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        var dateComponent = DateComponents()
        dateComponent.year = years
        dateComponent.month = months
        dateComponent.day = days
        guard let date = calendar.date(byAdding: dateComponent, to: Date()) else {
            XCTFail("Tried to set datepicker to invalid date")
            return "Fail"
        }
        
        let year = calendar.component(.year, from: date)
        let monthName = dateFormatter.monthSymbols[calendar.component(.month, from: date) - 1] // Apparently calendar.component() gives months 1-12 instead of 0-11
        let day = calendar.component(.day, from: date)
        
        editItemReleaseDateField.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "\(monthName)")
        editItemReleaseDateField.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(day)")
        editItemReleaseDateField.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "\(year)")
        
        return dateFormatter.string(from: date)
    }
    
    private func contextMenu(_ name: String) -> XCUIElement {
        return app.scrollViews.otherElements.buttons[name]
    }
    
    private func chooseFromContextMenu(_ name: String) {
        contextMenu(name).tap()
    }
    
    private func tapNavButton(_ name: String) {
        getNavigationBar().buttons[name].tap()
    }
    
    // TODO: This is a workaround until card view is implemented
    private func toggleItemState(_ item: XCUIElement) {
        item.coordinate(withNormalizedOffset: CGVector(dx: 0.06, dy: 0.5)).tap()
    }
    
    private func toggleShowCompletedItems() {
        app.images["Toggle Completed"].tap()
    }
}

