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
    @State var showCompleted: Bool = false
    @Binding var dirtyHack: Bool
    let language = DomainSpecificLanguage.defaultLanguage
    
    var body: some View {
        VStack {
            EditableTitle(title: domain.name ?? language.defaultItemTitle.title) { title in
                self.domain.name = title
                do {
                    try self.managedObjectContext.save()
                    self.dirtyHack.toggle()
                    return true
                } catch {
                    return false
                }
            }.padding(.top).padding(.horizontal)
            Picker("Show \(language.queue.title) or \(language.backlog.title)", selection: $showBacklog) {
                Text(language.queue.title)
                    .accessibility(identifier: "Queue Segment")
                    .tag(false)
                Text(language.backlog.title)
                    .accessibility(identifier: "Backlog Segment")
                    .tag(true)
            }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding(.horizontal)
                .accessibility(identifier: "Queue/Backlog Segment")
            
            AddByNameField("Add \(language.item.title)", dirtyHack: $dirtyHack) { (name: String) in
                let item = DomainItem.create(context: self.managedObjectContext, name: name)
                self.addToList(item)
                self.dirtyHack.toggle()
            }
                .padding(.top).padding(.horizontal)
                .accessibility(identifier: "Add Item")
            
            if !showBacklog {
                HStack {
                    Spacer()
                    Image(systemName: showCompleted ? "eye.fill" : "eye.slash")
                        .onTapGesture {
                            self.showCompleted.toggle()
                        }
                        .accessibility(identifier: "Toggle Completed")
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            if showBacklog {
                ItemList(self.domain.backlogItems, dirtyHack: $dirtyHack)
            } else if showCompleted {
                ItemList(self.domain.queueItems, dirtyHack: $dirtyHack)
            } else {
                ItemList(self.domain.queueItems.filter { item in
                    item.status != .completed
                }, dirtyHack: $dirtyHack)
            }
        }
            .navigationBarItems(
                trailing: EditButton()
            )
            .navigationBarTitle("", displayMode: .inline)
            .onAppear() {
                if self.domain.processScheduledMoves() {
                    do {
                        try self.managedObjectContext.save()
                        self.dirtyHack.toggle()
                    } catch {
                        print("Failed to save changes.")
                    }
                }
            }
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
