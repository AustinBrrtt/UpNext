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
    var items: Set<DomainItem>
    
    var body: some View {
        return List {
            ForEach(Array(items).sorted()) { item in
                Text(item.name ?? "Untitled")
            }.onDelete { (offsets: IndexSet) in
                for index in offsets {
                    self.managedObjectContext.delete((Array(self.items).sorted())[index])
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
