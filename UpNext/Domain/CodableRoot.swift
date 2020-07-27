//
//  ExportData.swift
//  UpNext
//
//  Created by Austin Barrett on 5/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

// TODO: Reading/Writing from CoreData replacementf
class CodableRoot: Codable {
    var domains: [CodableDomain]
    
    static func fromJSONString(_ json: String) -> CodableRoot? {
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    init(domains: [Domain]) {
        self.domains = domains.map { CodableDomain($0) }
    }
    
    func overwrite(model: DomainsModel) throws {
        model.deleteAll()
        model.replace(domains: domains.map{ $0.asDomain() })
    }
    
    struct CodableDomain: Codable {
        var id: Int64
        var name: String
        var queue: [CodableDomainItem]
        var backlog: [CodableDomainItem]
        
        init(_ domain: Domain) {
            id = domain.id
            name = domain.name
            queue = []
            backlog = []
            
            for item in domain.queue {
                queue.append(CodableDomainItem(item))
            }
            
            for item in domain.backlog {
                backlog.append(CodableDomainItem(item))
            }
        }
        
        func asDomain () -> Domain {
            var domain = Domain(id: id, name: name)
            
            for item in queue {
                domain.queue.append(item.asDomainItem(queued: true))
            }
            
            for item in backlog {
                domain.backlog.append(item.asDomainItem(queued: false))
            }
            
            return domain
        }
    }
    
    struct CodableDomainItem: Codable {
        public var id: Int64
        public var name: String
        public var notes: String?
        public var status: String
        public var isRepeat: Bool?
        public var moveOnRelease: Bool
        public var sortIndex: Int64
        public var releaseDate: Date?
        
        init(_ item: DomainItem) {
            id = item.id
            name = item.name
            notes = item.notes
            status = item.status.oldRawValue
            moveOnRelease = item.moveOnRelease
            sortIndex = item.sortIndex
            releaseDate = item.releaseDate
        }
        
        func asDomainItem(queued: Bool) -> DomainItem {
            return DomainItem(id: id, name: name, notes: notes, status: ItemStatus.from(rawValue: status) ?? .unstarted, queued: queued, moveOnRelease: moveOnRelease, sortIndex: sortIndex, releaseDate: releaseDate)
        }
    }
}
