//
//  DomainList.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/23/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainList: View {
    @EnvironmentObject var model: DomainsModel
    @Environment(\.editMode) var editMode
    @Binding var domains: [Domain]
    let language = DomainSpecificLanguage.defaultLanguage
    
    var body: some View {
        NavigationView {
            VStack {
                AddByNameField("Add \(language.domain.title)") { (name: String) in
                    model.addDomain(name: name)
                }
                    .padding()
                    .accessibility(identifier: "Add Domain")
                List {
                    ForEach(domains.enumerated().map({$0}), id: \.0) { (index, domain) in
                        if (editMode?.wrappedValue == .active) {
                            Text(domain.name)
                                .listItem()
                        } else {
                            NavigationLink(destination: DomainView(domain: $domains[index])) {
                                Text(domain.name)
                                    .listItem()
                            }
                        }
                    }.onDelete { (offsets: IndexSet) in
                        for index in offsets {
                            model.delete(domains[index])
                        }
                    }
                }
            }
            .navigationBarTitle(language.domain.pluralTitle)
            .navigationBarItems(
                leading: NavigationLink(destination: ImportExportView()) {
                    Text("Import/Export")
                },
                trailing: EditButton()
            )
        }
    }
}

struct DomainList_Previews: PreviewProvider {
    static var domains: [Domain] {
        return [
            Domain.createMock(
                name: "Games",
                unstarted: [
                    DomainItem.createMock(name: "The Legend of Zelda", notes: "Really good game", status: .started, releaseDate: Date(timeIntervalSince1970: 509400000)),
                    DomainItem.createMock(name: "Hitman 2", status: .started),
                    DomainItem.createMock(name: "Shrek SuperSlam")
                ],
                backlog: [
                    DomainItem.createMock(name: "Hitman 3", moveOnRelease: true, releaseDate: Date(timeIntervalSinceReferenceDate: 631200000)),
                    DomainItem.createMock(name: "Thief"),
                    DomainItem.createMock(name: "Mario & Luigi: Bowser's Inside Story")
                ]
            ),
            Domain.createMock(name: "Books", unstarted: [DomainItem.createMock(name: "No content")]),
            Domain.createMock(name: "Anime", unstarted: [DomainItem.createMock(name: "No content")])
        ]
    }
    static var previews: some View {
        DomainList(domains: .constant(domains))
    }
}
