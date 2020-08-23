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
    let queue: Bool
    
    
    init(_ domain: Binding<Domain>, queue: Bool, showCompleted: Binding<Bool> = Binding<Bool>(get: { return true }, set: { _ in })) {
        self._domain = domain
        self.queue = queue
        self._showCompleted = showCompleted
    }
    
    var body: some View {
        VStack {
            List {
                if (queue) {
                    if (showCompleted) {
                        ItemListSection($domain, status: .completed, showCompleted: $showCompleted)
                            .environmentObject(model)
                    }
                    ItemListSection($domain, status: .started, showCompleted: $showCompleted)
                        .environmentObject(model)
                    ItemListSection($domain, status: .unstarted, showCompleted: $showCompleted)
                        .environmentObject(model)
                } else {
                    ItemListSection($domain, status: .backlog, showCompleted: $showCompleted)
                        .environmentObject(model)
                }
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
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
        ItemList(domain, queue: true)
            .environmentObject({ () -> DomainsModel in  let d = DomainsModel(); d.domains = [domain.wrappedValue]; return d }())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
