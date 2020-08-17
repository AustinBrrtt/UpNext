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
        ItemList(domain, queue: true)
            .environmentObject({ () -> DomainsModel in  let d = DomainsModel(); d.domains = [domain.wrappedValue]; return d }())
        .previewLayout(.fixed(width: 450, height: 350))
    }
}
