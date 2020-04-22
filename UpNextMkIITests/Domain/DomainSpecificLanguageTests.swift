//
//  DomainSpecificLanguageTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/6/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import Up_Next

class DomainSpecificLanguageTests: UpNextTestCase {
    
    // init() with defaults
    func testInitWithDefaults() {
        let dsl = DomainSpecificLanguage()
        
        XCTAssert(dsl.domain.normal == "list")
        XCTAssert(dsl.domainTitle.normal == "title")
        XCTAssert(dsl.queue.normal == "up next")
        XCTAssert(dsl.backlog.normal == "backlog")
        XCTAssert(dsl.item.normal == "item")
        XCTAssert(dsl.itemTitle.normal == "title")
        XCTAssert(dsl.defaultItemTitle.normal == "untitled")
    }
    
    // init() with defaults
    func testInitNoDefaults() {
        let dsl = DomainSpecificLanguage(domain: Noun("foo"), domainTitle: Noun("bar"), queue: Noun("baz"), backlog: Noun("bat"), item: Noun("ban"), itemTitle: Noun("baw"), defaultItemTitle: Noun("bap"))
        
        XCTAssert(dsl.domain.normal == "foo")
        XCTAssert(dsl.domainTitle.normal == "bar")
        XCTAssert(dsl.queue.normal == "baz")
        XCTAssert(dsl.backlog.normal == "bat")
        XCTAssert(dsl.item.normal == "ban")
        XCTAssert(dsl.itemTitle.normal == "baw")
        XCTAssert(dsl.defaultItemTitle.normal == "bap")
    }
}
