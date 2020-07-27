//
//  DomainView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    @EnvironmentObject var model: DomainsModel
    @Binding var domain: Domain
    @State var showBacklog: Bool = false
    @AppStorage("showCompleted") var showCompleted: Bool = false
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        VStack {
            EditableTitle(title: domain.name) { title in
                model.renameDomain(domain, to: title)
            }
            .padding(.top)
            .padding(.horizontal)
            
            Picker("Show Up Next or Backlog", selection: $showBacklog) {
                Text("Up Next")
                    .accessibility(identifier: "Queue Segment")
                    .tag(false)
                Text("Backlog")
                    .accessibility(identifier: "Backlog Segment")
                    .tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(.horizontal)
            .accessibility(identifier: "Queue/Backlog Segment")
            
            AddByNameField("Add Item") { (name: String) in
                model.addItem(name: name, in: showBacklog ? .backlog : .queue, of: domain)
            }
            .padding(.top)
            .padding(.horizontal)
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
                ItemList($domain, type: .backlog)
            } else {
                ItemList($domain, type: .queue, showCompleted: $showCompleted)
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
        var domain = Domain(name: "Games")
        domain.queue = queueItems
        domain.backlog = backlogItems
        domain.queue[0].releaseDate = Date(timeIntervalSince1970: 509400000)
        domain.queue[0].notes = "Really good game"
        domain.queue[0].isRepeat = true
        domain.queue[0].status = .started
        domain.queue[1].status = .started
        domain.backlog[0].releaseDate = Date(timeIntervalSinceReferenceDate: 631200000)
        domain.backlog[0].moveOnRelease = true
        return domain
    }
    
    static var previews: some View {
        NavigationView {
            NavigationLink(destination: DomainView(domain: .constant(domain)), isActive: .constant(true)) {
                EmptyView()
                    .navigationTitle("Lists")
            }
        }
    }
}
