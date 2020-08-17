//
//  ItemListSection.swift
//  UpNext
//
//  Created by Austin Barrett on 8/12/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Combine
import SwiftUI

struct ItemListSection: View {
    @EnvironmentObject var model: DomainsModel
    @Binding var domain: Domain
    @Binding var showCompleted: Bool
    @Binding var items: [DomainItem]
    let status: ItemStatus
    
    init(_ domain: Binding<Domain>, status: ItemStatus = .backlog, showCompleted: Binding<Bool>) {
        self._domain = domain
        self.status = status
        self._showCompleted = showCompleted
        switch status {
        case .backlog:
            self._items = domain.backlog
        case .unstarted:
            self._items = domain.unstarted
        case .started:
            self._items = domain.started
        case .completed:
            self._items = domain.completed
        }
    }
    
    var body: some View {
        ForEach(items) { item in
            ItemCardView(item: item, domain: $domain)
        }
        .onDelete { (offsets: IndexSet) in
            for index in offsets {
                model.delete(items[index])
            }
        }
        .onMove { (src: IndexSet, dst: Int) in
            model.reorderItems(in: status, of: domain, src: src, dst: dst)
        }
    }
    
//    private func mappedIndex(for index: Int) -> Int {
//        if (status == .backlog || status == .completed) {
//            return index
//        }
//        
//        let offset = (showCompleted ? domain.completed.count : 0) + (status == .unstarted ? domain.started.count : 0)
//        print(index - offset)
//        print(itemIndices[index - offset])
//        return itemIndices[index - offset]
//    }
}

struct ItemListSection_Previews: PreviewProvider {
    static var domain: Binding<Domain> {
        var domain = Domain(name: "Temp")
        domain.completed = [
            DomainItem(name: "The Legend of Zelda"),
            DomainItem(name: "Hitman 2"),
            DomainItem(name: "Shrek SuperSlam")
        ]
        domain.started = [
            DomainItem(name: "The Incredibles"),
            DomainItem(name: "Japan: The Game"),
            DomainItem(name: "Tacos with Me")
        ]
        domain.unstarted = [
            DomainItem(name: "Bugsnax"),
            DomainItem(name: "Spider-man: Homecoming"),
            DomainItem(name: "Free Pizza")
        ]
        return .constant(domain)
    }
    
    static var previews: some View {
        ItemListSection(domain, status: .unstarted, showCompleted: .constant(true))
        .environmentObject(DomainsModel())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
