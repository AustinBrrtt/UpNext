//
//  DomainList.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/23/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainList: View {
    @Environment(\.editMode) var editMode
    @Binding var domains: [Domain]
    let language = DomainSpecificLanguage.defaultLanguage
    
    var body: some View {
        NavigationView {
            VStack {
                AddByNameField("Add \(language.domain.title)") { (name: String) in
                    let _ = Domain.create(name: name)
                }
                    .padding()
                    .accessibility(identifier: "Add Domain")
                List {
                    ForEach(domains) { domain in
                        if (editMode?.wrappedValue == .active) {
                            Text(domain.displayName)
                                .listItem()
                        } else {
                            NavigationLink(destination: DomainView(domain: domain)) {
                                Text(domain.displayName)
                                    .listItem()
                            }
                        }
                    }.onDelete { (offsets: IndexSet) in
//                        for index in offsets {
                            // TODO: Delete domains[index]
//                        }
                    }
                }
            }
            .navigationBarTitle(language.domain.pluralTitle)
            .navigationBarItems(
                leading: NavigationLink(destination: ImportExportView(domains: $domains)) {
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
        let domain = Domain(name: "Games")
        domain.queue = queueItems
        domain.backlog = backlogItems
        domain.queue[0].releaseDate = Date(timeIntervalSince1970: 509400000)
        domain.queue[0].notes = "Really good game"
        domain.queue[0].isRepeat = true
        domain.queue[0].status = .started
        domain.queue[1].status = .started
        domain.backlog[0].releaseDate = Date(timeIntervalSinceReferenceDate: 631200000)
        domain.backlog[0].moveOnRelease = true
        domain.queue.forEach { item in
            item.inQueueOf = domain
        }
        domain.backlog.forEach { item in
            item.inBacklogOf = domain
        }
        return [domain, Domain(name: "Books"), Domain(name: "Anime")]
    }
    static var previews: some View {
        DomainList(domains: .constant(domains))
    }
}
