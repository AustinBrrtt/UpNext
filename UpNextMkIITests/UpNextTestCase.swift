//
//  UpNextTestCase.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 4/21/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import Up_Next

class UpNextTestCase: XCTestCase {
    func dateFromComponents(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)
    }
}
