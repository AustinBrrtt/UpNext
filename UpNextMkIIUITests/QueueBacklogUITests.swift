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
    
    // #171346745 - I want the keyboard to dismiss when I tap the add button
    func testAddButtonDismissesKeyboard() {
        addItem("Foo")
        
        XCTAssert(app.keyboards.count == 0)
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
        dragHandle.swipeDown()
        
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
    
    // #170897812 - I want to be able to edit item properties
    func testEditItemProperties() {
        let qa = getItem("QA")
        let qb = getItem("QB")
        let editedTitle1 = "Modern Twist"
        let editedTitle2 = "Antiquated Meme"
        
        // Long press QA and choose Edit
        qa.longPress()
        chooseFromContextMenu("Edit")
        
        // Expect edit title field to be shown
        XCTAssert(editItemNameField.exists)
        
        // Edit Title to "Modern Twist" and tap "Save"
        editItemNameField.replaceText(editedTitle1)
        tapNavButton("Save")
        
        // Confirm we are back on the previous page
        XCTAssert(qb.exists)
        
        // Check that name has changed
        let editedItem = getItem(editedTitle1)
        XCTAssertFalse(qa.exists)
        XCTAssert(editedItem.exists)
        
        // Go to backlog and back to queue as workaround for #171037978
        // (#171037978 prevents navigation to a child view immediately after pressing back from that view - Simulator only)
        backlogSegment.tap()
        queueSegment.tap()
        
        // Reenter Edit Page
        editedItem.longPress()
        chooseFromContextMenu("Edit")
        
        // Edit title to "Antiquated Meme" and tap "Cancel"
        editItemNameField.replaceText(editedTitle2)
        tapNavButton("Cancel")
        
        // Confirm we are back on the previous page
        XCTAssert(qb.exists)
        
        // Check that name has not been changed
        let reeditedItem = getItem(editedTitle2)
        XCTAssert(editedItem.exists)
        XCTAssertFalse(reeditedItem.exists)
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
        editItemNameField.replaceText("   leading")
        tapNavButton("Save")
        
        // Check that the leading spaces have been removed
        XCTAssertFalse(getItem("   leading").exists)
        XCTAssert(getItem("leading").exists)
        
        // Long press QB and choose Edit
        qb.longPress()
        chooseFromContextMenu("Edit")
        
        // Edit title and tap "Save"
        editItemNameField.replaceText("trailing   ")
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
        editItemNameField.clearText()
        
        // Type the keys
        let keys = [ "F", "o", "o", "space", "B", "a", "r" ]
        for key in keys {
            let key = app.keys[key]
            XCTAssertTrue(key.exists)
            key.tap()
        }
        
        tapNavButton("Save")
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
