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
    let queued = Expression<Bool>("queued")
    let notes = Expression<String?>("notes")
    let status = Expression<Int64>("status")
    let moveOnRelease = Expression<Bool>("moveOnRelease")
    let sortIndex = Expression<Int64>("sortIndex")
    let releaseDate = Expression<Date?>("releaseDate")
    
    var domainsWithAllColumns: Table {
        domains.select(id, name)
    }
    
    var itemsWithAllColumns: Table {
        items.select(id, name, domain, queued, notes, status, moveOnRelease, sortIndex, releaseDate)
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
                t.column(queued)
                t.column(notes, defaultValue: nil)
                t.column(status, defaultValue: ItemStatus.unstarted.rawValue)
                t.column(moveOnRelease, defaultValue: false)
                t.column(sortIndex, defaultValue: 1)
                t.column(releaseDate, defaultValue: nil)
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
    
    func importDomain(domain: Domain) {
        _ = try? db.run(domains.insert(self.name <- domain.name))
        for item in domain.queue + domain.backlog {
            importItem(item: item, domainId: domain.id)
        }
    }
    
    func importItem(item: DomainItem, domainId: Int64) {
        _ = try? db.run(items.insert(self.name <- item.name, self.domain <- domainId, self.queued <- item.queued, self.notes <- item.notes, self.status <- item.status.rawValue, self.moveOnRelease <- item.moveOnRelease, self.sortIndex <- item.sortIndex, self.releaseDate <- item.releaseDate))
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
    
    func moveItem(_ id: Int64, to destination: ItemListType) {
        updateItem(id) { $0.update(self.queued <- destination == .queue) }
    }
    
    func reorderItem(_ id: Int64, to sortIndex: Int64) {
        updateItem(id) { $0.update(self.sortIndex <- sortIndex) }
    }
    
    func updateItemStatus(_ id: Int64, to status: ItemStatus) {
        updateItem(id) { $0.update(self.status <- status.rawValue) }
    }
    
    func releaseItem(_ id: Int64) {
        updateItem(id) { $0.update(self.queued <- true, self.moveOnRelease <- false) }
    }
    
    func editItem(_ id: Int64, to newValue: DomainItem) {
        updateItem(id) { $0.update(self.name <- newValue.name, self.notes <- newValue.notes, self.status <- newValue.status.rawValue, self.moveOnRelease <- newValue.moveOnRelease, self.releaseDate <- newValue.releaseDate) }
    }
    
    func createItem(name: String, in type: ItemListType, of domainId: Int64) -> DomainItem? {
        do {
            let id = try db.run(items.insert(self.name <- name, self.domain <- domainId, self.queued <- type == .queue))
            return parseItem(from: try db.pluck(itemsWithAllColumns.filter(self.id == id).limit(1))!)
        } catch {
            print("Error: createItem")
            return nil
        }
    }
    
    func parseDomain(from row: Row) -> Domain? {
        do {
            let domainId = try row.get(self.id)
            var domain = try Domain(id: domainId, name: row.get(self.name), queue: [], backlog: [])
            for itemRow in try db.prepare(itemsWithAllColumns.filter(self.domain == domainId)) {
                if let item = parseItem(from: itemRow) {
                    if item.queued {
                        domain.queue.append(item)
                    } else {
                        domain.backlog.append(item)
                    }
                }
            }
            domain.queue.sort()
            domain.backlog.sort()
            return domain
        } catch {
            print("Error: parseDomain")
            return nil
        }
    }
    
    func parseItem(from row: Row) -> DomainItem? {
        do {
            return try DomainItem(id: row.get(self.id), name: row.get(self.name), notes: row.get(self.notes), status: ItemStatus(rawValue: row.get(self.status))!, queued: row.get(self.queued), moveOnRelease: row.get(self.moveOnRelease), sortIndex: row.get(self.sortIndex), releaseDate: row.get(self.releaseDate))
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
            let foo = try db.run(update(items.filter(self.id == id)))
            print("Success: updateItem #\(id), result = \(foo)")
        } catch {
            print("Error: updateItem")
            return
        }
    }
}