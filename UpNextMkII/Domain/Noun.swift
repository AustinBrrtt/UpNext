//
//  Noun.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 2/9/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

struct Noun {
    // Normal mid-sentence usage: "The [normal] is under the couch"
    let normal: String
    
    // Beginning of sentence: "[capitalized] is a good thing"
    let capitalized: String
    
    // In Titles
    let title: String
    
    // Normal mid-sentence plural usage: "The [plural] are under the couch"
    let plural: String
    
    // Plural at beginning of sentence: "[capitalized]s are pretty cool"
    let pluralCapitalized: String
    
    // Plural in Titles
    let pluralTitle: String
    
    // Add more as needed
    
    init(_ normal: String, capitalized: String? = nil, title: String? = nil, plural: String? = nil, pluralCapitalized: String? = nil, pluralTitle: String? = nil) {
        self.normal = normal
        
        // Use custom value if provided or capitalize the first letter of normal
        if let capitalized = capitalized {
            self.capitalized = capitalized
        } else {
            self.capitalized = normal.uppercaseFirstLetter()
        }
        
        // Use custom value if provided or capitalize the first letter of each word in normal
        if let title = title {
            self.title = title
        } else {
            self.title = normal.capitalized(with: nil)
        }
        
        // Use custom value if provided or add an s to normal
        if let plural = plural {
            self.plural = plural
        } else {
            self.plural = normal + "s"
        }
        
        // Use custom value if provided
        // Otherwise if no custom plural was provided and a custom capitalized was provided, add an s to capitalized
        // Otherwise (i.e. custom plural was provided or no custom capitalized was provided), capitalize the first letter of plural
        if let pluralCapitalized = pluralCapitalized {
            self.pluralCapitalized = pluralCapitalized
        } else if let capitalized = capitalized, plural == nil {
            self.pluralCapitalized = capitalized + "s"
        } else {
            self.pluralCapitalized = self.plural.uppercaseFirstLetter()
        }
        
        // Use custom value if provided
        // Otherwise if no custom plural was provided and a custom title was provided, add an s to title
        // Otherwise (i.e. custom plural was provided or no custom title was provided), capitalize the first letter of each word of plural
        if let pluralTitle = pluralTitle {
            self.pluralTitle = pluralTitle
        } else if let title = title, plural == nil {
            self.pluralTitle = title + "s"
        }  else {
            self.pluralTitle = self.plural.capitalized(with: nil)
        }
        
    }
}

extension String {
    func uppercaseFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
