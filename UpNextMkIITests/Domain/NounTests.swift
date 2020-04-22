//
//  NounTests.swift
//  UpNextMkIITests
//
//  Created by Austin Barrett on 2/9/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import XCTest
@testable import Up_Next

class NounTests: UpNextTestCase {
    
    // init() with only normal provided
    func testInitNormalOnly() {
        let noun = Noun("test word")
        
        XCTAssertEqual(noun.normal, "test word")
        XCTAssertEqual(noun.capitalized, "Test word")
        XCTAssertEqual(noun.title, "Test Word")
        XCTAssertEqual(noun.plural, "test words")
        XCTAssertEqual(noun.pluralCapitalized, "Test words")
        XCTAssertEqual(noun.pluralTitle, "Test Words")
    }
    
    // init() with normal and capitalized provided
    func testInitCapitalized() {
        let noun = Noun("test word", capitalized: "fiNger paLace")
        
        XCTAssertEqual(noun.normal, "test word")
        XCTAssertEqual(noun.capitalized, "fiNger paLace")
        XCTAssertEqual(noun.title, "Test Word")
        XCTAssertEqual(noun.plural, "test words")
        XCTAssertEqual(noun.pluralCapitalized, "fiNger paLaces")
        XCTAssertEqual(noun.pluralTitle, "Test Words")
    }
    
    // init() with normal and title provided
    func testInitTitle() {
        let noun = Noun("test word", title: "fiNger paLace")
        
        XCTAssertEqual(noun.normal, "test word")
        XCTAssertEqual(noun.capitalized, "Test word")
        XCTAssertEqual(noun.title, "fiNger paLace")
        XCTAssertEqual(noun.plural, "test words")
        XCTAssertEqual(noun.pluralCapitalized, "Test words")
        XCTAssertEqual(noun.pluralTitle, "fiNger paLaces")
    }
    
    // init() with normal and plural provided
    func testInitPlural() {
        let noun = Noun("northern moose", plural: "northern meese")
        
        XCTAssertEqual(noun.normal, "northern moose")
        XCTAssertEqual(noun.capitalized, "Northern moose")
        XCTAssertEqual(noun.title, "Northern Moose")
        XCTAssertEqual(noun.plural, "northern meese")
        XCTAssertEqual(noun.pluralCapitalized, "Northern meese")
        XCTAssertEqual(noun.pluralTitle, "Northern Meese")
    }
    
    // init() with normal and pluralCapitalized provided
    func testInitPluralCapitalized() {
        let noun = Noun("federal nomenclature", pluralCapitalized: "feDeral noMenclatures")
        
        XCTAssertEqual(noun.normal, "federal nomenclature")
        XCTAssertEqual(noun.capitalized, "Federal nomenclature")
        XCTAssertEqual(noun.title, "Federal Nomenclature")
        XCTAssertEqual(noun.plural, "federal nomenclatures")
        XCTAssertEqual(noun.pluralCapitalized, "feDeral noMenclatures")
        XCTAssertEqual(noun.pluralTitle, "Federal Nomenclatures")
    }
    
    // init() with normal and pluralTitle provided
    func testInitPluralTitle() {
        let noun = Noun("federal nomenclature", pluralTitle: "feDeral noMenclatures")
        
        XCTAssertEqual(noun.normal, "federal nomenclature")
        XCTAssertEqual(noun.capitalized, "Federal nomenclature")
        XCTAssertEqual(noun.title, "Federal Nomenclature")
        XCTAssertEqual(noun.plural, "federal nomenclatures")
        XCTAssertEqual(noun.pluralCapitalized, "Federal nomenclatures")
        XCTAssertEqual(noun.pluralTitle, "feDeral noMenclatures")
    }
    
    // init() with normal, capitalized, and plural provided
    func testInitCapitalizedAndPlural() {
        let noun = Noun("northern moose", capitalized: "northERn mooSe", plural: "northern meese")
        
        XCTAssertEqual(noun.normal, "northern moose")
        XCTAssertEqual(noun.capitalized, "northERn mooSe")
        XCTAssertEqual(noun.title, "Northern Moose")
        XCTAssertEqual(noun.plural, "northern meese")
        XCTAssertEqual(noun.pluralCapitalized, "Northern meese")
        XCTAssertEqual(noun.pluralTitle, "Northern Meese")
    }
    
    // init() with normal, title, and plural provided
    func testInitTitleAndPlural() {
        let noun = Noun("northern moose", title: "northERn mooSe", plural: "northern meese")
        
        XCTAssertEqual(noun.normal, "northern moose")
        XCTAssertEqual(noun.capitalized, "Northern moose")
        XCTAssertEqual(noun.title, "northERn mooSe")
        XCTAssertEqual(noun.plural, "northern meese")
        XCTAssertEqual(noun.pluralCapitalized, "Northern meese")
        XCTAssertEqual(noun.pluralTitle, "Northern Meese")
    }
}
