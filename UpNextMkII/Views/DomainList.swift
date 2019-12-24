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
    @State var newDomainName: String = ""
    @FetchRequest(fetchRequest: Domain.getAll()) var domains: FetchedResults<Domain>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add Domain", text: $newDomainName)
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(newDomainName == "" ? .secondary : .green)
                        .onTapGesture {
                            if (self.newDomainName != "") {
                                let _ = Domain.create(context: self.managedObjectContext, name: self.newDomainName)
                                
                                do {
                                    try self.managedObjectContext.save()
                                    self.newDomainName = ""
                                } catch let error as NSError {
                                    // TODO: Handle CoreData save error
                                    print("Saving failed. \(error), \(error.userInfo)")
                                }
                            }
                    }
                }
                .padding()
                List {
                    ForEach(domains) { domain in
                        if (self.editMode?.wrappedValue == .active) {
                            Text(domain.name ?? "Untitled")
                        } else {
                            NavigationLink(destination: DomainView(domain: domain)) {
                                Text(domain.name ?? "Untitled")
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
