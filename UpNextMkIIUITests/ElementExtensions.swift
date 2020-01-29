//
//  ElementExtensions.swift
//  UpNextMkIIUITests
//
//  Created by Austin Barrett on 1/28/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest

extension XCUIElement {
    func typeCarefully(_ text: String) {
        for char in text {
            typeText(String(char))
        }
    }
}
