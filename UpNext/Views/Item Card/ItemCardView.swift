//
//  ItemCardView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 5/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

// TODO: Refactor into smaller views
// TODO: iPad Navigation
// TODO: Mac Navigation
struct ItemCardView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var model: DomainsModel
    let language = DomainSpecificLanguage.defaultLanguage
    @State var isPropertiesShown: Bool = false
    @State var expanded: Bool = false
    
    var item: DomainItem
    @Binding var domain: Domain
    
    var startDoneButtonIcon: String {
        switch item.status {
        case .completed:
            return "checkmark.circle.fill"
        case .started:
            return "play.fill"
        case .unstarted:
            return "play"
        case .backlog:
            return "nosign"
        }
    }
    
    var startDoneButtonText: String {
        switch item.status {
        case .backlog:
            return "Error"
        case .completed:
            return "Restart"
        case .started:
            return "Finish"
        case .unstarted:
            return "Start"
        }
    }
    
    var startDoneButtonBackgroundColor: Color {
        switch item.status {
        case .backlog, .completed:
            return .red
        case .started:
            return .blue
        case .unstarted:
            return .secondaryBackground
        }
    }
    
    var startDoneButtonForegroundColor: Color {
        if item.status == .unstarted {
            return .primary
        } else {
            return .white
        }
    }
    
    var editing: Bool {
        editMode?.wrappedValue == .active
    }
    
    var body: some View {
       ZStack {
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(10)
                .foregroundColor(.secondaryBackground)
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            expanded.toggle()
                        }
                    }) {
                        Text(item.name)
                            .listItem(bold: item.status == .started)
                            .contextMenu {
                                Button(action: {
                                    isPropertiesShown = true
                                }) {
                                    HStack {
                                        Text("Edit")
                                        Image(systemName: "pencil")
                                    }
                                }
                                
                                Button(action: {
                                    model.move(item: item, to: item.status == .backlog ? .unstarted : .backlog, of: domain)
                                }) {
                                    HStack {
                                        Text(item.status == .backlog ? "Move to Up Next" : "Move to Backlog")
                                        Image(systemName: item.status == .backlog ? "arrow.left.to.line" : "arrow.right.to.line")
                                    }
                                }
                                
                                Button(action: {
                                    model.delete(item)
                                }) {
                                    HStack {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }.foregroundColor(.red) // As of February 2020, coloring this doesn't work due to a bug in SwiftUI
                            }
                    }
                    Spacer()
                    if item.status != .backlog && !editing {
                        SolidButton(startDoneButtonText, foreground: startDoneButtonForegroundColor, background: startDoneButtonBackgroundColor) {
                            model.updateItemStatus(item: item, to: item.status.next())
                        }
                        .accessibility(identifier: "Complete Item " + item.name)
                    }
                }
                
                ItemCardIndicatorsView(item: item)
                
                if expanded && !editing {
                    VStack {
                        HStack {
                            if let notes = item.notes {
                                Text(notes)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Text("No notes")
                                    .foregroundColor(.secondary)
                            }
                            Spacer(minLength: 0)
                        }.padding(.bottom)
                        
                        HStack {
                            Spacer(minLength: 0)
                            SolidButton("Edit", background: .clear) { // TODO: shared parent for SolidButton without bg
                                isPropertiesShown = true
                            }
                        }
                    }
                    .transition(.identity)
                }
            }
            .foregroundColor(item.hasFutureReleaseDate ? .secondary : .primary)
            .padding()
            .sheet(isPresented: $isPropertiesShown) {
                ItemPropertiesView(item) {
                    isPropertiesShown = false
                }
                .environmentObject(model)
            }
        }
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var basicBacklogItem = DomainItem(name: "Backlog Item")
    static var complexBacklogItem: DomainItem {
        var item = DomainItem(name: "Backlog Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.moveOnRelease = true
        return item
    }
    static var futureBacklogItem: DomainItem {
        var item = DomainItem(name: "Future Backlog Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 6000000000)
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.moveOnRelease = true
        return item
    }
    static var completedQueueItem: DomainItem {
        var item = DomainItem(name: "Completed Queue Item")
        item.status = .completed
        return item
    }
    static var startedQueueItem: DomainItem {
        var item = DomainItem(name: "Started Queue Item")
        item.status = .started
        return item
    }
    static var unstartedQueueItem = DomainItem(name: "Unstarted Queue Item")
    static var complexQueueItem: DomainItem {
        var item = DomainItem(name: "Unstarted Queue Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        return item
    }
    static var futureQueueItem: DomainItem {
        var item = DomainItem(name: "Future Unstarted Queue Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 6000000000)
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        return item
    }
    
    static var model: DomainsModel {
        let model = DomainsModel()
        model.domains.append(Domain(name: "Queue Holder"))
        model.domains[0].unstarted = [
            completedQueueItem,
            startedQueueItem,
            unstartedQueueItem,
            complexQueueItem,
            futureQueueItem
        ]
        model.domains[0].backlog = [
            basicBacklogItem,
            complexBacklogItem,
            futureBacklogItem
        ]
        return model
    }
    
    struct PreviewContainer: View {
        @EnvironmentObject var model: DomainsModel
        
        var body: some View {
            VStack {
                ForEach(model.domains[0].backlog) { item in
                    ItemCardView(item: item, domain: .constant(model.domains[0]))
                        .frame(width: 400)
                        .padding(.bottom)
                }
                Divider()
                ForEach(model.domains[0].unstarted) { item in
                    ItemCardView(item: item, domain: .constant(model.domains[0]))
                        .frame(width: 400)
                        .padding(.bottom)
                }
            }
        }
    }

    static var previews: some View {
        PreviewContainer()
            .environmentObject(model)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
