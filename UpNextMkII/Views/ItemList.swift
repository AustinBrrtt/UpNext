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
    var _items: Set<DomainItem>
    var items: [DomainItem] {
        return _items.map() { (item: DomainItem) in item } // TODO: Inefficiently regenerated each time
    }
    
    init (items: Set<DomainItem>) {
        _items = items
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name ?? "Untitled")
            }.onDelete { (offsets: IndexSet) in
                for index in offsets {
                    self.managedObjectContext.delete(self.items[index])
                }
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList(items: Set<DomainItem>()) // TODO: CoreData preview
    }
}
