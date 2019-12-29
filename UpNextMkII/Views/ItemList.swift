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
    @Binding var dirtyHack: Bool
    
    var body: some View {
        return List {
            ForEach(items) { item in
                Text(item.name ?? "Untitled")
            }.onDelete { (offsets: IndexSet) in
                for index in offsets {
                    self.managedObjectContext.delete(self.items[index])
                }
                self.dirtyHack.toggle()
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList(items: [], dirtyHack: .constant(true)) // TODO: CoreData preview
    }
}
