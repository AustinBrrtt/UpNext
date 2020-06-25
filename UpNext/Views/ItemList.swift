//
//  ItemList.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    var items: [DomainItem]
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ items: [DomainItem]) {
        self.items = items
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                ItemCardView(item: item)
            }
            .onDelete { (offsets: IndexSet) in
                for index in offsets {
                    // TODO: Delete items[index]
                }
            }
            .onMove { (src: IndexSet, dst: Int) in
                
                // TODO: This is most likely preferable, especially with insertions and such
                // Change queue from one-to-many to one-to-one, add a next and previous relationship to DomainItem and do linked list insertions
                // let domain = items[0].domain
                // let set = items[0].isInQueue ? domain.queue : domain.backlog
                
                // print("original")
                // for (index, item) in items.enumerated() {
                //     print(item.name ?? "Untitled", index)
                // }
                var mutableList = Array(items)
                mutableList.move(fromOffsets: src, toOffset: dst)
                // print("reordered")
                for (index, item) in mutableList.enumerated() {
                    print(item.name ?? language.defaultItemTitle.title, index)
                    item.sortIndex = Int16(index)
                }
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList([]) // TODO: CoreData preview
    }
}
