//
//  ItemProperties.swift
//  UpNext
//
//  Created by Austin Barrett on 6/27/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

// Configurable properties for a DomainItem
struct ItemProperties {
    var title: String
    var status: ItemStatus
    var notes: String
    var isRepeat: Bool
    var useDate: Bool
    var date: Date
    var moveOnRelease: Bool
    
    init(from item: DomainItem) {
        title = item.name
        status = item.status
        notes = item.notes ?? ""
        isRepeat = item.isRepeat
        useDate = item.releaseDate != nil
        date = item.releaseDate ?? Date()
        moveOnRelease = item.moveOnRelease
    }
}
