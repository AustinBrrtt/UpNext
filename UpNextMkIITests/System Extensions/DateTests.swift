//
//  DateTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 4/21/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import Up_Next

class DateTests: UpNextTestCase {
    // Returns the same day at noon
    func testNoon() {
        let midnight = dateFromComponents(year: 2020, month: 11, day: 21, hour: 0, minute: 0, second: 0)!
        let morning = dateFromComponents(year: 2020, month: 11, day: 21, hour: 9, minute: 37, second: 22)!
        let elevensies = dateFromComponents(year: 2020, month: 11, day: 21, hour: 11, minute: 58, second: 45)!
        let noon = dateFromComponents(year: 2020, month: 11, day: 21, hour: 12, minute: 0, second: 0)!
        let afternoon = dateFromComponents(year: 2020, month: 11, day: 21, hour: 12, minute: 2, second: 8)!
        let afterLunch = dateFromComponents(year: 2020, month: 11, day: 21, hour: 13, minute: 25, second: 13)!
        let evening = dateFromComponents(year: 2020, month: 11, day: 21, hour: 18, minute: 35, second: 31)!
        let night = dateFromComponents(year: 2020, month: 11, day: 21, hour: 23, minute: 59, second: 59)!
        
        XCTAssert(midnight.noon == morning.noon)
        XCTAssert(morning.noon == elevensies.noon)
        XCTAssert(elevensies.noon == noon.noon)
        XCTAssert(noon.noon == afternoon.noon)
        XCTAssert(afternoon.noon == afterLunch.noon)
        XCTAssert(afterLunch.noon == evening.noon)
        XCTAssert(evening.noon == night.noon)
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: noon)
        
        XCTAssert(components.year == 2020)
        XCTAssert(components.month == 11)
        XCTAssert(components.day == 21)
        XCTAssert(components.hour == 12)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)

    }
}
