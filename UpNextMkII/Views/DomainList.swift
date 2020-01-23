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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Domain.getAll()) var domains: FetchedResults<Domain>
    
    var body: some View {
        NavigationView {
            VStack {
                AddByNameField("Add Domain") { (name: String) in
                    let _ = Domain.create(context: self.managedObjectContext, name: name)
                }
                .padding()
                List {
                    ForEach(domains) { domain in
                        if (self.editMode?.wrappedValue == .active) {
                            Text(domain.displayName)
                        } else {
                            NavigationLink(destination: DomainView(domain: domain)) {
                                Text(domain.displayName)
                            }
                        }
                    }.onDelete { (offsets: IndexSet) in
                        for index in offsets {
                            self.managedObjectContext.delete(self.domains[index])
                        }
                    }
                }
            }
            .navigationBarTitle("Domains")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct DomainList_Previews: PreviewProvider {
    static var previews: some View {
        DomainList()
    }
}
