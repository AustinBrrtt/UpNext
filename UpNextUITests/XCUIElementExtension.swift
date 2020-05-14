//
//  XCUIElementExtension.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 2/1/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

extension XCUIElement {
    func soonExists() -> Bool {
        return self.waitForExistence(timeout: 5)
    }
    
    func isHigherThan(_ other: XCUIElement) -> Bool {
        return frame.origin.y < other.frame.origin.y
    }
    
    func tapBlockedElement() {
        coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5)).tap()
    }
    
    func longPress() {
        press(forDuration: 0.75)
    }
    
    func manualSwipeLeft() {
        self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).press(forDuration: 0.25, thenDragTo: self.coordinate(withNormalizedOffset: CGVector(dx: -1, dy: 0.5)))
    }
    
    func manualSwipeDown() {
        self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).press(forDuration: 0.25, thenDragTo: self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 1)))
    }
}
