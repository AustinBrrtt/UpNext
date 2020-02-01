//
//  XCUIElementExtension.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 2/1/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard let currentText = self.value as? String else {
            XCTFail("Tried to clear text from a non-text element")
            return
        }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        self.typeText(deleteString)
    }
    
    func soonExists() -> Bool {
        return self.waitForExistence(timeout: 5)
    }
}
