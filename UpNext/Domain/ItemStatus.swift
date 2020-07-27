//
//  ItemStatus.swift
//  UpNext
//
//  Created by Austin Barrett on 5/18/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

enum ItemStatus: Int64 {
    case unstarted = 0
    case started = 1
    case completed = 2
    
    var oldRawValue: String {
        switch self {
        case .unstarted:
            return "UNSTARTED"
        case .started:
            return "STARTED"
        case .completed:
            return "COMPLETED"
        }
    }
    
    @available(*, deprecated, message: "Use Int64 representation")
    public static func from(rawValue: String) -> ItemStatus? {
        switch rawValue {
        case "UNSTARTED":
            return .unstarted
        case "STARTED":
            return .started
        case "COMPLETED":
            return.completed
        default:
            return nil
        }
    }
    
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
