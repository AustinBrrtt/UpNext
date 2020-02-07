//
//  DomainSpecificLanguageTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/6/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import UpNextMkII

class DomainSpecificLanguageTests: XCTestCase {
    
    // Noun.init() with only normal provided
    func testNounInitNormalOnly() {
        let noun = Noun("test word")
        
        XCTAssertEqual(noun.normal, "test word")
        XCTAssertEqual(noun.capitalized, "Test word")
        XCTAssertEqual(noun.title, "Test Word")
        XCTAssertEqual(noun.plural, "test words")
        XCTAssertEqual(noun.pluralCapitalized, "Test words")
        XCTAssertEqual(noun.pluralTitle, "Test Words")
    }
}
