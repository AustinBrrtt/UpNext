//
//  ExportData.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 5/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI
import CoreData

class CodableRoot: Codable {
    var domains: [CodableDomain]
    
    static func fromJSONString(_ json: String) -> CodableRoot? {
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    init(domains: FetchedResults<Domain>) {
        self.domains = domains.map { CodableDomain($0) }
    }
    
    func overwriteCoreData(domains: FetchedResults<Domain>, context: NSManagedObjectContext) throws {
        try burnItToTheGround(domains: domains, context: context)
            try writeToCoreData(context: context)
    }
    
    private func writeToCoreData(context: NSManagedObjectContext) throws {
        let _ = self.domains.map { $0.asDomain(context: context) }
        try context.save()
    }
    
    private func burnItToTheGround(domains: FetchedResults<Domain>, context: NSManagedObjectContext) throws {
        domains.forEach { domain in
            domain.queue.forEach { item in
                context.delete(item)
            }
            domain.backlog.forEach { item in
                context.delete(item)
            }
            context.delete(domain)
        }
        try context.save()
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
        
        func asDomain (context: NSManagedObjectContext) -> Domain {
            let domain = Domain(context: context)
            domain.name = name
            domain.queue = Set<DomainItem>()
            domain.backlog = Set<DomainItem>()
            
            for item in queue {
                domain.queue.insert(item.asDomainItem(context: context))
            }
            
            for item in backlog {
                domain.backlog.insert(item.asDomainItem(context: context))
            }
            
            return domain
        }
    }
    
    struct CodableDomainItem: Codable {
        public var name: String?
        public var completed: Bool
        public var isRepeat: Bool
        public var moveOnRelease: Bool
        public var sortIndex: Int16
        public var releaseDate: Date?
        
        init(_ item: DomainItem) {
            name = item.name
            completed = item.completed
            isRepeat = item.isRepeat
            moveOnRelease = item.moveOnRelease
            sortIndex = item.sortIndex
            releaseDate = item.releaseDate
        }
        
        func asDomainItem(context: NSManagedObjectContext) -> DomainItem {
            let item = DomainItem(context: context)
            item.name = name
            item.completed = completed
            item.isRepeat = isRepeat
            item.moveOnRelease = moveOnRelease
            item.sortIndex = sortIndex
            item.releaseDate = releaseDate
            return item
        }
    }
}
