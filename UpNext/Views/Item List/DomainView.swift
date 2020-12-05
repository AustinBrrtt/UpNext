//
//  DomainView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    @EnvironmentObject var model: AppModel
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
                model.addItem(name: name, in: showBacklog ? .backlog : .unstarted, of: domain)
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
                .padding(.vertical, 5)
            }
            
            if showBacklog {
                ItemList($domain, queue: false)
            } else {
                ItemList($domain, queue: true, showCompleted: $showCompleted)
            }
        }
        .navigationBarItems(
            trailing: EditButton()
        )
        .navigationBarTitle("", displayMode: .inline)
        .onAppear() {
            _ = model.processScheduledMoves(for: domain)
        }
        .environment(\.editMode, $editMode)
    }
}

struct DomainView_Previews: PreviewProvider {
    static var domain = Domain.createMock(
        name: "Games",
        unstarted: [
            DomainItem.createMock(name: "The Legend of Zelda", notes: "Really good game", status: .started, releaseDate: Date(timeIntervalSince1970: 509400000)),
            DomainItem.createMock(name: "Hitman 2", status: .started),
            DomainItem.createMock(name: "Shrek SuperSlam")
        ],
        backlog: [
            DomainItem.createMock(name: "Hitman 3", moveOnRelease: true, releaseDate: Date(timeIntervalSinceReferenceDate: 631200000)),
            DomainItem.createMock(name: "Thief"),
            DomainItem.createMock(name: "Mario & Luigi: Bowser's Inside Story")
        ]
    )
    
    static var previews: some View {
        NavigationView {
            NavigationLink(destination: DomainView(domain: .constant(domain)), isActive: .constant(true)) {
                EmptyView()
                    .navigationTitle("Lists")
            }
        }
    }
}
