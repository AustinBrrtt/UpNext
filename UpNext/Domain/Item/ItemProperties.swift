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
    var useDate: Bool
    var date: Date
    var moveOnRelease: Bool
    var inSeries: Bool
    var seriesName: String
    
    init(from item: DomainItem) {
        title = item.name
        status = item.status
        notes = item.notes ?? ""
        useDate = item.releaseDate != nil
        date = item.releaseDate ?? Date()
        moveOnRelease = item.moveOnRelease
        inSeries = item.seriesName != nil
        seriesName = item.seriesName ?? ""
    }
    
    init(title: String, status: ItemStatus, notes: String? = nil, releaseDate: Date? = nil, moveOnRelease: Bool = false, seriesName: String? = nil) {
        self.title = title
        self.status = status
        self.notes = notes ?? ""
        self.useDate = releaseDate != nil
        self.date = releaseDate ?? Date()
        self.moveOnRelease = moveOnRelease
        self.inSeries = seriesName != nil
        self.seriesName = seriesName ?? ""
    }
}
