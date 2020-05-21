//
//  ItemStatus.swift
//  UpNext
//
//  Created by Austin Barrett on 5/18/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

enum ItemStatus: String {
    case unstarted = "UNSTARTED"
    case started = "STARTED"
    case completed = "COMPLETED"
    
    // returns the next status, looping around from the end
    func next() -> ItemStatus {
        switch self {
        case .unstarted:
            return .started
        case .started:
            return .completed
        case .completed:
            return .unstarted
        }
    }
}

extension ItemStatus: Comparable {
    // .unstarted < .started < .completed
    static func < (lhs: ItemStatus, rhs: ItemStatus) -> Bool {
        switch lhs {
        case .unstarted:
            return rhs != .unstarted
        case .started:
            return rhs == .completed
        case .completed:
            return false
        }
    }
}
