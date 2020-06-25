//
//  DomainView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    var domain: Domain
    @State var showBacklog: Bool = false
    @State var showCompleted: Bool = false
    @State var editMode: EditMode = .inactive
    let language = DomainSpecificLanguage.defaultLanguage
    
    var body: some View {
        VStack {
            EditableTitle(title: domain.name ?? language.defaultItemTitle.title) { title in
                domain.name = title
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
            
            AddByNameField("Add \(language.item.title)") { (name: String) in
                let item = DomainItem.create(name: name)
                addToList(item)
            }
                .padding(.top).padding(.horizontal)
                .accessibility(identifier: "Add Item")
            
            if !showBacklog {
                HStack {
                    Spacer()
                    Image(systemName: showCompleted ? "eye.fill" : "eye.slash")
                        .padding(.top)
                        .onTapGesture {
                            showCompleted.toggle()
                        }
                        .accessibility(identifier: "Toggle Completed")
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            if showBacklog {
                ItemList(domain.backlogItems)
            } else if showCompleted {
                ItemList(domain.queueItems)
            } else {
                ItemList(domain.queueItems.filter { item in
                    item.status != .completed
                })
            }
        }
            .navigationBarItems(
                trailing: EditButton()
            )
            .navigationBarTitle("", displayMode: .inline)
            .onAppear() {
                _ = domain.processScheduledMoves()
            }
        .environment(\.editMode, $editMode)
    }
    
    func addToList(_ item: DomainItem) {
        if showBacklog {
            domain.addToBacklog(item)
        } else {
            domain.addToQueue(item)
        }
    }
}

struct DomainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO") // todo: CoreData in preview
    }
}
