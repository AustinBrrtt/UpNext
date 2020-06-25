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
    static var previews: some View {
        DomainList(domains: .constant([]))
    }
}
