//
//  ItemList.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var items: [DomainItem]
    
    init(_ items: [DomainItem]) {
        self.items = items
    }
    
    var body: some View {
        return List {
            ForEach(items) { item in
                Text(item.name ?? "Untitled")
            }.onDelete { (offsets: IndexSet) in
                for index in offsets {
                    self.managedObjectContext.delete(self.items[index])
                }
            }
            .onMove { (src: IndexSet, dst: Int) in
                
                // TODO: This is most likely preferable, especially with insertions and such
                // Change queue from one-to-many to one-to-one, add a next and previous relationship to DomainItem and do linked list insertions
                // let domain = self.items[0].domain
                // let set = self.items[0].isInQueue ? domain.queue : domain.backlog
                
                // TODO: toggling DirtyHack does not refresh core data anymore
                
                // print("original")
                // for (index, item) in self.items.enumerated() {
                //     print(item.name ?? "Untitled", index)
                // }
                var mutableList = Array(self.items)
                mutableList.move(fromOffsets: src, toOffset: dst)
                // print("reordered")
                for (index, item) in mutableList.enumerated() {
                    print(item.name ?? "Untitled", index)
                    item.sortIndex = Int16(index)
                }
                self.saveCoreData()
            }
        }
    }
    
    private func saveCoreData() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            // TODO: Handle CoreData save error
            print("Saving failed. \(error), \(error.userInfo)")
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList([]) // TODO: CoreData preview
    }
}
