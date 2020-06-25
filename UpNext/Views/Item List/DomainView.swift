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
    static var domain: Domain {
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
        return domain
    }
    
    static var previews: some View {
        NavigationView {
            NavigationLink(destination: DomainView(domain: domain), isActive: .constant(true)) {
                EmptyView()
                    .navigationTitle("Lists")
            }
        }
    }
}
