//
//  ItemListType.swift
//  UpNext
//
//  Created by Austin Barrett on 6/28/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

enum ItemListType {
    case queue
    case backlog
    
    var other: ItemListType {
        return self == .queue ? .backlog : .queue
    }
    
    func keyPath(forDomainIndex index: Int) -> WritableKeyPath<[Domain], [DomainItem]> {
        return self == .queue ? \[Domain][index].queue : \[Domain][index].backlog
    }
}
