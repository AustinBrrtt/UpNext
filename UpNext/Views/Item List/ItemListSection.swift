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
}

struct ItemListSection_Previews: PreviewProvider {
    static var domain: Binding<Domain> = .constant(Domain.createMock(
        name: "Temp",
        unstarted: [
            DomainItem.createMock(name: "Bugsnax"),
            DomainItem.createMock(name: "Spider-man: Homecoming"),
            DomainItem.createMock(name: "Free Pizza")
        ],
        started: [
            DomainItem.createMock(name: "The Incredibles"),
            DomainItem.createMock(name: "Japan: The Game"),
            DomainItem.createMock(name: "Tacos with Me")
        ],
        completed: [
            DomainItem.createMock(name: "The Legend of Zelda"),
            DomainItem.createMock(name: "Hitman 2"),
            DomainItem.createMock(name: "Shrek SuperSlam")
        ]
    ))
    
    static var previews: some View {
        ItemListSection(domain, status: .unstarted, showCompleted: .constant(true))
        .environmentObject(DomainsModel())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
