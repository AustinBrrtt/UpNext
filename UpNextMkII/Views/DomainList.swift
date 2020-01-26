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
    @State var dirtyHack: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                AddByNameField("Add Domain", dirtyHack: $dirtyHack) { (name: String) in
                    let _ = Domain.create(context: self.managedObjectContext, name: name)
                    self.dirtyHack.toggle()
                }
                .padding()
                List {
                    ForEach(dirtyHack ? domains : domains) { domain in
                        if (self.editMode?.wrappedValue == .active) {
                            Text(domain.displayName)
                                .listItem()
                        } else {
                            NavigationLink(destination: DomainView(domain: domain, dirtyHack: self.$dirtyHack)) {
                                Text(domain.displayName)
                                    .listItem()
                            }
                        }
                    }.onDelete { (offsets: IndexSet) in
                        for index in offsets {
                            self.managedObjectContext.delete(self.domains[index])
                            self.dirtyHack.toggle()
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
