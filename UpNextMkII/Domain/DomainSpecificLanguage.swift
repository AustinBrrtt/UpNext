//
//  DomainSpecificLanguage.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 2/3/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

// Yes, this class name is a joke
struct DomainSpecificLanguage {
    static let defaultLanguage: DomainSpecificLanguage = DomainSpecificLanguage()
    
    let domain: Noun
    let domainTitle: Noun
    let queue: Noun
    let backlog: Noun
    let item: Noun
    let itemTitle: Noun
    let defaultItemTitle: Noun
    
    init(
        domain: Noun = Noun("list"),
        domainTitle: Noun = Noun("title"),
        queue: Noun = Noun("up next"),
        backlog: Noun = Noun("backlog"),
        item: Noun = Noun("item"),
        itemTitle: Noun = Noun("title"),
        defaultItemTitle: Noun = Noun("untitled")
    ) {
        self.domain = domain
        self.item = item
        self.queue = queue
        self.backlog = backlog
        self.itemTitle = itemTitle
        self.domainTitle = domainTitle
        self.defaultItemTitle = defaultItemTitle
    }
}
