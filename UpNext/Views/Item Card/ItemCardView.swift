//
//  ItemCardView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 5/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

enum ItemPropertiesModalContent {
    case editItem
    case addSequel
}

// TODO: Refactor into smaller views
// TODO: iPad Navigation
// TODO: Mac Navigation
struct ItemCardView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var model: AppModel
    @State var modalContent: ItemPropertiesModalContent = .editItem
    @State var isSequelAddPromptShown: Bool = false
    @State var isModalShown: Bool = false
    @State var expanded: Bool = false
    @State var onModalClose: () -> Void = {} // FIXME: Temporary workaround until two-way binding is set up like in Budge It
    
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
                        Text(item.displayName)
                            .listItem(bold: item.status == .started)
                            .contextMenu {
                                Button(action: {
                                    isModalShown = true
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
                                }
                                .foregroundColor(.red) // As of February 2020, coloring this doesn't work due to a bug in SwiftUI
                            }
                            .sheet(isPresented: $isModalShown) {
                                switch modalContent {
                                case .editItem:
                                    ItemPropertiesView(item, domain: domain) {
                                        handleModalClose()
                                    }
                                    .environmentObject(model)
                                case .addSequel:
                                    ItemPropertiesView(prequel: item, domain: domain) {
                                        handleModalClose()
                                    }
                                    .environmentObject(model)
                                }
                            }
                    }
                    Spacer()
                    if item.status != .backlog && !editing {
                        SolidButton(startDoneButtonText, foreground: startDoneButtonForegroundColor, background: startDoneButtonBackgroundColor) {
                            let status = item.status.next()
                            if item.seriesName != nil && status == .completed && !domain.hasSequel(to: item) {
                                isSequelAddPromptShown = true
                                onModalClose = {
                                    model.updateItemStatus(item: item, to: status) // TODO: This causes View to re-initialize and resets all @State vars (two-way binding might fix this)
                                }
                            } else {
                                model.updateItemStatus(item: item, to: status)
                            }
                        }
                        .accessibility(identifier: "Complete Item " + item.name)
                        .actionSheet(isPresented: $isSequelAddPromptShown) {
                            ActionSheet(
                                title: Text("Add Next in Series?"),
                                buttons: [
                                    .default(Text("Add Item")) {
                                        modalContent = .addSequel
                                        isModalShown = true
                                    },
                                    .cancel(Text("Do Not Add Item")) {
                                        handleModalClose() // To call and reset onModalClose
                                    }
                                ]
                            )
                        }
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
                                modalContent = .editItem
                                isModalShown = true
                            }
                        }
                    }
                    .transition(.identity)
                }
            }
            .foregroundColor(item.hasFutureReleaseDate ? .secondary : .primary)
            .padding()
        }
    }
    
    private func handleModalClose() {
        isModalShown = false
        onModalClose()
        onModalClose = {}
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var basicBacklogItem = DomainItem.createMock(name: "Backlog Item")
    static var complexBacklogItem = DomainItem.createMock(name: "Backlog Item with properties", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!", moveOnRelease: true, releaseDate: Date(timeIntervalSinceReferenceDate: 600000000))
    static var futureBacklogItem = DomainItem.createMock(name: "Future Backlog Item with properties", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!", moveOnRelease: true, releaseDate: Date(timeIntervalSinceReferenceDate: 6000000000))
    static var completedQueueItem = DomainItem.createMock(name: "Completed Queue Item", status: .completed)
    static var startedQueueItem = DomainItem.createMock(name: "Started Queue Item", status: .started)
    static var unstartedQueueItem = DomainItem.createMock(name: "Unstarted Queue Item", status: .unstarted)
    static var complexQueueItem = DomainItem.createMock(name: "Unstarted Queue Item with properties", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!", releaseDate: Date(timeIntervalSinceReferenceDate: 600000000))
    static var futureQueueItem = DomainItem.createMock(name: "Future Unstarted Queue Item with properties", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!", releaseDate: Date(timeIntervalSinceReferenceDate: 6000000000))
    
    static var model: AppModel = {
        let model = AppModel()
        model.domains.append(Domain.createMock(
            name: "Queue Holder",
            unstarted: [
                completedQueueItem,
                startedQueueItem,
                unstartedQueueItem,
                complexQueueItem,
                futureQueueItem
            ],
            backlog: [
                basicBacklogItem,
                complexBacklogItem,
                futureBacklogItem
            ])
        )
        return model
    }()
    
    struct PreviewContainer: View {
        @EnvironmentObject var model: AppModel
        
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
