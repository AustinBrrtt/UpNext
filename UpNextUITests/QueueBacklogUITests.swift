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
    
    var editItemNameField: XCUIElement {
        app.textFields["Item Title"]
    }
    
    var editItemNotesField: XCUIElement {
        app.textViews["Item Notes"]
    }
    
    var editItemRepeatToggle: XCUIElement {
        app.scrollViews.otherElements.switches["Completed Previously"]
    }
    
    var toggleItemReleaseDateField: XCUIElement {
        app.scrollViews.otherElements.switches["Show Release Date"]
    }
    
    var editItemReleaseDateField: XCUIElement {
        app.scrollViews.otherElements.datePickers["Release Date"]
    }
    
    var editItemAddOnReleaseToggle: XCUIElement {
        app.scrollViews.otherElements.switches["Add to Queue on Release"]
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
    
    // #171043130 - I want to see the queue
    // #170438798 - I want to see the backlog
    func testViewQueueAndBacklog() {
        let qItem = getItem("QA")
        let bItem = getItem("BA")
        
        // Check that we are in queue
        XCTAssert(qItem.exists)
        XCTAssertFalse(bItem.exists)
        
        // Check if backlog segment exists and tap on it
        XCTAssert(backlogSegment.exists)
        backlogSegment.tap()
        
        // Check that we are in backlog
        XCTAssert(bItem.exists)
        XCTAssertFalse(qItem.exists)
        
        // Check if queue segment exists and tap on it
        XCTAssert(queueSegment.exists)
        queueSegment.tap()
        
        // Check that we are in queue
        XCTAssert(qItem.exists)
        XCTAssertFalse(bItem.exists)
    }
    
    // #171043188 - I want to add items to the queue
    // #170438808 - I want to add items to the backlog
    func testAddItemsToQueueAndBacklog() {
        // Add an item to queue and check that it is there
        addItem("QC")
        XCTAssert(getItem("QC").exists)
        
        // Go to the backlog, add an item to backlog, and check that it is there
        backlogSegment.tap()
        addItem("BC")
        XCTAssert(getItem("BC").exists)
        
        // Restart the app
        app.terminate()
        app.launch()
        getDomain(testDomainTitle).tap()
        
        // Check that the item is still in the queue
        XCTAssert(getItem("QC").exists)
        
        // Go to the backlog and check that the item is still in the backlog
        backlogSegment.tap()
        XCTAssert(getItem("BC").exists)
    }
    
    // #170640293 - I want to move items from my backlog to my queue and vice versa
    // #170908110 - Newly moved items [should be] moved to end of queue
    func testMoveItems() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        let ba = getItem("BA")
        let bb = getItem("BB")
        
        // Long press QA and choose Move To Backlog in menu
        qa.longPress()
        chooseFromContextMenu("Move to Backlog") // Can't get item to be recognized by accessibility identifier, resorting to literal string
        
        // Check that QA is gone
        XCTAssertFalse(qa.exists)
        
        // Go to backlog and check that QA appears after BA and BB
        backlogSegment.tap()
        XCTAssert(qa.exists)
        XCTAssert(ba.isHigherThan(qa))
        XCTAssert(bb.isHigherThan(qa))
        
        // Long press BA and choose Move To Queue in menu
        ba.longPress()
        chooseFromContextMenu("Move to Up Next") // Can't get item to be recognized by accessibility identifier, resorting to literal string
        
        // Check that BA is gone
        XCTAssertFalse(ba.exists)
        
        // Go to queue and check that BA appears after QB
        queueSegment.tap()
        XCTAssert(ba.exists)
        XCTAssert(qb.isHigherThan(ba))
    }
    
    
    // #170908104 - I want to set items to move automatically from the backlog to the queue on their release date
    func testAddOnRelease() {
        backlogSegment.tap()
        let ba = getItem("BA")
        
        // Set release date to tomorrow
        ba.longPress()
        chooseFromContextMenu("Edit")
        toggleItemReleaseDateField.tap()
        let tomorrowText = "BA - \(setDatePickerValueToTodayPlus(days: 1))"
        
        // Add on release toggle exists for backlog, turn it on and save
        XCTAssert(editItemAddOnReleaseToggle.exists)
        editItemAddOnReleaseToggle.tap()
        tapNavButton("Save")
        
        // Item is still in backlog
        let baTomorrow = getItem(tomorrowText)
        XCTAssert(baTomorrow.exists)
        
        // Workaround for #171037978 Simulator bug
        queueSegment.tap()
        backlogSegment.tap()
        
        // Set release date to today and save
        baTomorrow.longPress()
        chooseFromContextMenu("Edit")
        let todayText = "BA - \(setDatePickerValueToTodayPlus())"
        tapNavButton("Save")
        
        // Item is not in backlog
        let baToday = getItem(todayText)
        XCTAssertFalse(ba.exists)
        XCTAssertFalse(baToday.exists)
        
        // Item has been moved to queue because release date has passed, and it is on top
        queueSegment.tap()
        XCTAssert(baToday.exists)
        XCTAssert(baToday.isHigherThan(getItem("QA")))
    }
    
    // #170897812 - I want to be able to edit item properties
    // #171034432 - I want to easily clear text in name editing/entering text fields
    // #170897793 - I want to set release dates for items
    // #170897744 - I want to mark items as previously completed
    // #170908104 - I want to set items to move automatically from the backlog to the queue on their release date
    // #172666238 - I want to tap on an item to visit its properties page
    // Note: This test requires Auto-Correction and Smart Punctuation to be turned off, which I have currently done in the Simulator
    func testEditItemProperties() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        let editedTitle1 = "Modern Twist"
        let editedTitle2 = "Antiquated Meme"
        let editedNotes1 = "To be, or not to be, that is the question:\nWhether 'tis nobler in the mind to suffer\nThe slings and arrows..."
        let editNotes2 = "Not "
        
        // Long press QA and choose Edit
        qa.longPress()
        chooseFromContextMenu("Edit")
        
        // Expect fields to be shown/hidden
        XCTAssert(editItemNameField.exists)
        XCTAssert(toggleItemReleaseDateField.exists)
        XCTAssert(editItemRepeatToggle.exists)
        XCTAssertFalse(editItemReleaseDateField.exists)
        
        // Enable release date toggle and expect fields to be shown
        toggleItemReleaseDateField.tap()
        XCTAssert(editItemReleaseDateField.exists)
        XCTAssertFalse(editItemAddOnReleaseToggle.exists) // Only shows on backlog items
        
        // Edit title to "Modern Twist", date to tomorrow,, repeat to true, and tap "Save"
        app.images.firstMatch.tap() // Tap clear button
        editItemNameField.tap()
        editItemNameField.typeText(editedTitle1)
        editItemRepeatToggle.tap()
        let dateString = setDatePickerValueToTodayPlus(days: 1)
        editItemNotesField.tap()
        type(editedNotes1)
        tapNavButton("Save")
        
        // Confirm we are back on the previous page
        XCTAssert(qb.exists)
        
        // Check that name has changed
        let fullItemText = "\(editedTitle1) (again) - \(dateString)"
        let editedItem = getItem(fullItemText)
        XCTAssertFalse(qa.exists)
        XCTAssert(editedItem.exists)
        
        // Go to backlog and back to queue as workaround for #171037978
        // (#171037978 prevents navigation to a child view immediately after pressing back from that view - Simulator only)
        backlogSegment.tap()
        queueSegment.tap()
        
        // Reenter Edit Page
        editedItem.tap()
        XCTAssertEqual(editItemNotesField.value as! String, editedNotes1) // TODO: Cannot currently check notes value, check the static text when card the view is added
        
        // Edit title to "Antiquated Meme", date to 2 days from now, repeat to false and tap "Cancel"
        app.images.firstMatch.tap() // Tap clear button
        editItemNameField.tap()
        editItemNameField.typeText(editedTitle2)
        editItemRepeatToggle.tap()
        editItemNotesField.tap()
        type(editNotes2) // Note that we currently don't test that this value is discarded. Check the static text when the card view is added
        let secondDateString = setDatePickerValueToTodayPlus(days: 2)
        tapNavButton("Cancel")
        
        // Confirm we are back on the previous page
        XCTAssert(qb.exists)
        
        // Check that name has not been changed
        let nextFullItemText = "\(editedTitle2) - \(secondDateString)"
        let reeditedItem = getItem(nextFullItemText)
        XCTAssert(editedItem.exists)
        XCTAssertFalse(reeditedItem.exists)
    }
    
    // #171120829 - I want to delete items
    // #170967352 - Deleted objects should remain deleted after quitting and reopening the app
    func testDeleteItem() {
        // Delete from queue through standard list delete button
        deleteItem("QA")
        XCTAssertFalse(getItem("QA").exists)
        
        // Delete from backlog via context menu
        backlogSegment.tap()
        getItem("BB").longPress()
        chooseFromContextMenu("Delete")
        XCTAssertFalse(getItem("BB").exists)
        
        restartApp()
        getDomain(testDomainTitle).tap()
        
        // Check that QA is still gone after restarting the app
        XCTAssertFalse(getItem("QA").exists)
        
        // Check that BB is still gone after restarting the app
        backlogSegment.tap()
        XCTAssertFalse(getItem("BB").exists)
                
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
    
    private func deleteItem(_ name: String) {
        let item = getItem(name)
        item.manualSwipeLeft()
        app.tables/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
