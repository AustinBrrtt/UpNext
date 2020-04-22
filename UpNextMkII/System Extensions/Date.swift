//
//  Date.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 4/21/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

extension Date {
    var noon: Date {
        var hour = Calendar.current.component(.hour, from: self)
        var date = self
        if hour == 12 {
            date = Calendar.current.date(byAdding: .hour, value: -1, to: date)!
            hour = 11
        }
        var direction = Calendar.SearchDirection.backward
        if hour < 12 {
            direction = .forward
        }
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self, direction: direction)!
    }
}
