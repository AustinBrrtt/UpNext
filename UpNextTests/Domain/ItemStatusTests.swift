//
//  ItemStatusTests.swift
//  UpNextTests
//
//  Created by Austin Barrett on 5/20/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNext

class ItemStatusTests: UpNextTestCase {
    func testLessThan() {
        // .unstarted < .started < .completed
        XCTAssert(ItemStatus.unstarted < ItemStatus.started)
        XCTAssert(ItemStatus.started < ItemStatus.completed)
        XCTAssert(ItemStatus.unstarted < ItemStatus.completed)
        
        XCTAssertFalse(ItemStatus.started < ItemStatus.unstarted)
        XCTAssertFalse(ItemStatus.completed < ItemStatus.started)
        XCTAssertFalse(ItemStatus.completed < ItemStatus.unstarted)
        
        XCTAssertFalse(ItemStatus.unstarted < ItemStatus.unstarted)
        XCTAssertFalse(ItemStatus.started < ItemStatus.started)
        XCTAssertFalse(ItemStatus.completed < ItemStatus.completed)
    }
}
