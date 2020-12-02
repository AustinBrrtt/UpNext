//
//  Database.swift
//  UpNext
//
//  Created by Austin Barrett on 7/1/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation
import SQLite

class Database {
    let db: Connection
    let domains = Table("domains")
    let items = Table("items")
    
    let id = Expression<Int64>("rowid")
    let name = Expression<String>("name")
    
    let domain = Expression<Int64>("domain")
    let notes = Expression<String?>("notes")
    let status = Expression<Int64>("status")
    let moveOnRelease = Expression<Bool>("moveOnRelease")
    let sortIndex = Expression<Int64>("sortIndex")
    let releaseDate = Expression<Date?>("releaseDate")
    let seriesName = Expression<String?>("seriesName")
    
    var domainsWithAllColumns: Table {
        domains.select(id, name)
    }
    
    var itemsWithAllColumns: Table {
        items.select(id, name, domain, notes, status, moveOnRelease, sortIndex, releaseDate, seriesName)
    }
    
    #if os(iOS)
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    #elseif os(macOS)
    let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
    #endif
    
    init?() {
        do {
            #if os(macOS)
            try FileManager.default.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            #endif
            db = try Connection("\(path)/db.sqlite3")
            
            try db.run(domains.create(ifNotExists: true) { t in
                t.column(name)
            })
            
            try db.run(items.create(ifNotExists: true) { t in
                t.column(name)
                t.column(domain, references: domains, id)
                t.column(notes, defaultValue: nil)
                t.column(status, defaultValue: ItemStatus.unstarted.rawValue)
                t.column(moveOnRelease, defaultValue: false)
                t.column(sortIndex, defaultValue: 1)
                t.column(releaseDate, defaultValue: nil)
                t.column(seriesName, defaultValue: nil)
            })
        } catch {
            assert(false, "Failed to initialize database")
            return nil
        }
    }
    
    func load() -> [Domain]? {
        var domainList: [Domain] = []
        do {
            for row in try db.prepare(domainsWithAllColumns) {
                if let domain = parseDomain(from: row) {
                    domainList.append(domain)
                }
            }
        } catch {
            return nil
        }
        domainList.sort(by: { lhs, rhs in lhs.name.localizedCompare(rhs.name) == .orderedAscending })
        return domainList
    }
    
    func deleteEverything() {
        _ = try? db.run(domains.delete())
        _ = try? db.run(items.delete())
    }
    
    // TODO: Use diff
    func save(domains: [Domain]) {
        // TODO: Is this needed? Currently doing database manipulations on insert/delete/update
    }
    
    // TODO: Allow restoring data by using delete flag?
    func deleteDomain(id: Int64) {
        _ = try? db.run(domains.filter(self.id == id).delete())
    }
    
    // TODO: Allow restoring data by using delete flag?
    func deleteItem(id: Int64) {
        _ = try? db.run(items.filter(self.id == id).delete())
    }
    
    // Returns the id of the domain if successful, nil if unsucessful
    func importDomain(domain: Domain) -> Int64? {
        guard let result = try? db.run(domains.insert(self.name <- domain.name)) else {
            return nil
        }
        
        for item in domain.items {
            guard let _ = importItem(item: item, domainId: result) else {
                return nil
            }
        }
        
        return result
    }
    
    // Returns the id of the item if successful, nil if unsucessful
    func importItem(item: DomainItem, domainId: Int64) -> Int64? {
        return try? db.run(items.insert(self.name <- item.name, self.domain <- domainId, self.notes <- item.notes, self.status <- item.status.rawValue, self.moveOnRelease <- item.moveOnRelease, self.sortIndex <- item.sortIndex, self.releaseDate <- item.releaseDate, self.seriesName <- item.seriesName))
    }
    
    func createDomain(name: String) -> Domain? {
        do {
            let id = try db.run(domains.insert(self.name <- name))
            return parseDomain(from: try db.pluck(domainsWithAllColumns.filter(self.id == id).limit(1))!)
        } catch {
            print("Error: createDomain")
            return nil
        }
    }
    
    func renameDomain(_ id: Int64, to name: String) {
        updateDomain(id) { $0.update(self.name <- name) }
    }
    
    func reorderItem(_ id: Int64, to sortIndex: Int64) {
        updateItem(id) { $0.update(self.sortIndex <- sortIndex) }
    }
    
    func updateItemStatus(_ id: Int64, to status: ItemStatus) {
        updateItem(id) { $0.update(self.status <- status.rawValue) }
    }
    
    func releaseItem(_ id: Int64) {
        updateItemStatus(id, to: .unstarted)
    }
    
    func editItem(_ id: Int64, to newValue: DomainItem) {
        updateItem(id) { $0.update(self.name <- newValue.name, self.notes <- newValue.notes, self.status <- newValue.status.rawValue, self.moveOnRelease <- newValue.moveOnRelease, self.releaseDate <- newValue.releaseDate, self.seriesName <- newValue.seriesName) }
    }
    
    func createItem(name: String, with status: ItemStatus, of domainId: Int64) -> DomainItem? {
        do {
            let id = try db.run(items.insert(self.name <- name, self.domain <- domainId, self.status <- status.rawValue))
            return parseItem(from: try db.pluck(itemsWithAllColumns.filter(self.id == id).limit(1))!)
        } catch {
            print("Error: createItem")
            return nil
        }
    }
    
    func parseDomain(from row: Row) -> Domain? {
        do {
            let domainId = try row.get(self.id)
            var domain = try Domain(id: domainId, name: row.get(self.name), unstarted: [], backlog: [])
            for itemRow in try db.prepare(itemsWithAllColumns.filter(self.domain == domainId)) {
                if let item = parseItem(from: itemRow) {
                    switch item.status {
                    case .backlog:
                        domain.backlog.append(item)
                    case .unstarted:
                        domain.unstarted.append(item)
                    case .started:
                        domain.started.append(item)
                    case .completed:
                        domain.completed.append(item)
                    }
                }
            }
            domain.unstarted.sort()
            domain.backlog.sort()
            return domain
        } catch {
            print("Error: parseDomain")
            return nil
        }
    }
    
    func parseItem(from row: Row) -> DomainItem? {
        do {
            return try DomainItem(id: row.get(self.id), name: row.get(self.name), notes: row.get(self.notes), status: ItemStatus(rawValue: row.get(self.status))!, moveOnRelease: row.get(self.moveOnRelease), sortIndex: row.get(self.sortIndex), releaseDate: row.get(self.releaseDate), seriesName: row.get(self.seriesName))
        } catch {
            print("Error: parseItem")
            return nil
        }
    }
    
    private func updateDomain(_ id: Int64, update: (Table) -> Update) {
        do {
            _ = try db.run(update(domains.filter(self.id == id)))
        } catch {
            print("Error: updateDomain")
            return
        }
    }
    
    private func updateItem(_ id: Int64, update: (Table) -> Update) {
        do {
            _ = try db.run(update(items.filter(self.id == id)))
        } catch {
            print("Error: updateItem")
            return
        }
    }
}
