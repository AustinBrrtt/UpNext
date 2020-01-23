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
    @Binding var dirtyHack: Bool
    
    var body: some View {
        VStack {
            EditableTitle(title: domain.name ?? "Untitled") { title in
                self.domain.name = title
                do {
                    try self.managedObjectContext.save()
                    self.dirtyHack.toggle()
                    return true
                } catch {
                    return false
                }
            }.padding()
            Picker("Show Up Next or Backlog", selection: $showBacklog) {
                Text("Up Next").tag(false)
                Text("Backlog").tag(true)
            }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding()
            
            AddByNameField("Add Item", dirtyHack: $dirtyHack) { (name: String) in
                let item = DomainItem.create(context: self.managedObjectContext, name: name)
                self.addToList(item)
                self.dirtyHack.toggle()
            }
            .padding()
            
            if showBacklog {
                ItemList(self.domain.backlogItems, dirtyHack: $dirtyHack)
            } else {
                ItemList(self.domain.queueItems, dirtyHack: $dirtyHack)
            }
        }
        .navigationBarItems(
            trailing: EditButton()
        )
        .navigationBarTitle("", displayMode: .inline)
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
