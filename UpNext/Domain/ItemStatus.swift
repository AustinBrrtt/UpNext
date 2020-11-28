//
//  ItemStatus.swift
//  UpNext
//
//  Created by Austin Barrett on 5/18/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

enum ItemStatus: Int64 {
    case backlog = 0
    case unstarted = 1
    case started = 2
    case completed = 3
    
    // returns the next status, looping around from the end,
    // with the exception of backlog which is not included
    func next() -> ItemStatus {
        switch self {
        case .backlog:
            return .backlog
        case .unstarted:
            return .started
        case .started:
            return .completed
        case .completed:
            return .unstarted
        }
    }
    
    func keyPath(forDomainIndex index: Int) -> WritableKeyPath<[Domain], [DomainItem]> {
        switch self {
        case .backlog:
            return \[Domain][index].backlog
        case .unstarted:
            return \[Domain][index].unstarted
        case .started:
            return \[Domain][index].started
        case .completed:
            return \[Domain][index].completed
        }
    }
}

// TODO: Is this still used?
extension ItemStatus: Comparable {
    // .unstarted < .started < .completed
    static func < (lhs: ItemStatus, rhs: ItemStatus) -> Bool {
        switch lhs {
        case .backlog:
            return rhs != .backlog
        case .unstarted:
            return rhs != .unstarted && rhs != .backlog
        case .started:
            return rhs == .completed
        case .completed:
            return false
        }
    }
}
