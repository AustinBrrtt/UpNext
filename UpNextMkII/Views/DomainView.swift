//
//  DomainView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var domain: Domain
    @State var showBacklog: Bool = false
    
    var body: some View {
        VStack {
            EditableTitle(title: domain.name ?? "Untitled") { title in
                self.domain.name = title
                return (try? self.managedObjectContext.save()) != nil
            }.padding()
            Picker("Show Up Next or Backlog", selection: $showBacklog) {
                Text("Up Next").tag(false)
                Text("Backlog").tag(true)
            }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding()
            
            AddByNameField("Add Item") { (name: String) in
                let item = DomainItem.create(context: self.managedObjectContext, name: name)
                self.addToList(item)
            }
            .padding()
            
            if showBacklog {
                ItemList(self.domain.backlogItems)
            } else {
                ItemList(self.domain.queueItems)
            }
        }
        .navigationBarItems(
            trailing: EditButton()
        )
    }
    
    func addToList(_ item: DomainItem) {
        if self.showBacklog {
            self.domain.addToBacklog(item)
        } else {
            self.domain.addToQueue(item)
        }
    }
}

struct DomainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO") // todo: CoreData in preview
    }
}
