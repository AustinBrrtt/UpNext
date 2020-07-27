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
    @Binding var domain: Domain
    @Binding var showCompleted: Bool
    let language = DomainSpecificLanguage.defaultLanguage
    let type: ItemListType
    
    init(_ domain: Binding<Domain>, type: ItemListType, showCompleted: Binding<Bool> = Binding<Bool>(get: { return true }, set: { _ in })) {
        self._domain = domain
        self.type = type
        self._showCompleted = showCompleted
    }
    
    var itemIndices: [Int] {
        type == .backlog ? domain.backlog.indices.map{$0} :
            showCompleted ? domain.queue.indices.map{$0} : filteredIndices
    }
    
    var filteredIndices: [Int] {
        domain.queue.indices.filter { domain.queue[$0].status != .completed }
    }
    
    var items: Binding<[DomainItem]> {
        type == .backlog ? $domain.backlog : $domain.queue
    }
    
    var body: some View {
        List {
            ForEach(itemIndices, id: \.self) { index in
                ItemCardView(item: items[index], domain: $domain, type: type)
            }
            .onDelete { (offsets: IndexSet) in
                for index in offsets {
                    model.delete(items.wrappedValue[index])
                }
            }
            .onMove { (src: IndexSet, dst: Int) in
                model.reorderItems(in: type, of: domain, src: src, dst: dst)
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var domain: Binding<Domain> {
        var domain = Domain(name: "Temp")
        domain.queue = [
            DomainItem(name: "The Legend of Zelda"),
            DomainItem(name: "Hitman 2"),
            DomainItem(name: "Shrek SuperSlam")
        ]
        return .constant(domain)
    }
    
    static var previews: some View {
        ItemList(domain, type: .queue)
        .environmentObject(DomainsModel())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
