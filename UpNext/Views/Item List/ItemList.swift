//
//  ItemList.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    @EnvironmentObject var model: DomainsModel
    @Binding var items: [DomainItem]
    @Binding var showCompleted: Bool
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ items: Binding<[DomainItem]>, showCompleted: Binding<Bool> = Binding<Bool>(get: { return true }, set: { _ in })) {
        self._items = items
        self._showCompleted = showCompleted
    }
    
    var filteredIndices: [Int] {
        showCompleted ? items.indices.map{$0} : items.indices.filter { items[$0].status != .completed }
    }
    
    var body: some View {
        List {
            ForEach(filteredIndices, id: \.self) { index in
                ItemCardView(item: $items[index])
            }
            .onDelete { (offsets: IndexSet) in
                for index in offsets {
                    model.delete(items[index])
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
//                    print(item.name ?? language.defaultItemTitle.title, index)
                    model.updateIndex(for: item, to: Int16(index))
                }
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList(.constant([
            DomainItem(name: "The Legend of Zelda"),
            DomainItem(name: "Hitman 2"),
            DomainItem(name: "Shrek SuperSlam")
        ]))
        .environmentObject(DomainsModel())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
