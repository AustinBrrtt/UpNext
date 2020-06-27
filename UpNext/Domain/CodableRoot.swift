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
    
    func overwrite(domains: [Domain]) throws {
        try burnItToTheGround(domains: domains)
            try writeToCoreData()
    }
    
    private func writeToCoreData() throws {
//        let _ = domains.map { $0.asDomain(context: context) }
//        try context.save()
    }
    
    private func burnItToTheGround(domains: [Domain]) throws {
//        domains.forEach { domain in
//            domain.queue.forEach { item in
//                context.delete(item)
//            }
//            domain.backlog.forEach { item in
//                context.delete(item)
//            }
//            context.delete(domain)
//        }
//        try context.save()
    }
    
    struct CodableDomain: Codable {
        var name: String?
        var queue: [CodableDomainItem]
        var backlog: [CodableDomainItem]
        
        init(_ domain: Domain) {
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
            let domain = Domain(name: name)
            
            for item in queue {
//                domain.queue.append(item.asDomainItem())
            }
            
            for item in backlog {
//                domain.backlog.append(item.asDomainItem())
            }
            
            return domain
        }
    }
    
    struct CodableDomainItem: Codable {
        public var name: String?
        public var status: String
        public var isRepeat: Bool
        public var moveOnRelease: Bool
        public var sortIndex: Int16
        public var releaseDate: Date?
        
        init(_ item: DomainItem) {
            name = item.name
            status = item.status.rawValue
            isRepeat = item.isRepeat
            moveOnRelease = item.moveOnRelease
            sortIndex = item.sortIndex
            releaseDate = item.releaseDate
        }
        
        func asDomainItem() -> DomainItem {
            let item = DomainItem(name: name)
//            item.status = ItemStatus(rawValue: status) ?? .unstarted
//            item.isRepeat = isRepeat
//            item.moveOnRelease = moveOnRelease
//            item.sortIndex = sortIndex
//            item.releaseDate = releaseDate
            return item
        }
    }
}
