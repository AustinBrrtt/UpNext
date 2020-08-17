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
    static var queueItems = [
        DomainItem(name: "The Legend of Zelda"),
        DomainItem(name: "Hitman 2"),
        DomainItem(name: "Shrek SuperSlam")
    ]
    static var backlogItems = [
        DomainItem(name: "Hitman 3"),
        DomainItem(name: "Thief"),
        DomainItem(name: "Mario & Luigi: Bowser's Inside Story")
    ]
    static var domains: [Domain] {
        var domain = Domain(name: "Games")
        domain.unstarted = queueItems
        domain.backlog = backlogItems
        domain.unstarted[0].releaseDate = Date(timeIntervalSince1970: 509400000)
        domain.unstarted[0].notes = "Really good game"
        domain.unstarted[0].status = .started
        domain.unstarted[1].status = .started
        domain.backlog[0].releaseDate = Date(timeIntervalSinceReferenceDate: 631200000)
        domain.backlog[0].moveOnRelease = true
        return [domain, Domain(name: "Books"), Domain(name: "Anime")]
    }
    static var previews: some View {
        DomainList(domains: .constant(domains))
    }
}
