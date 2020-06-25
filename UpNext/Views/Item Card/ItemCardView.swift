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
    let language = DomainSpecificLanguage.defaultLanguage
    @State var isPropertiesShown: Bool = false
    @State var expanded: Bool = false
    
    var item: DomainItem
    
    var startDoneButtonIcon: String {
        switch item.status {
        case .completed:
            return "checkmark.circle.fill"
        case .started:
            return "play.fill"
        case .unstarted:
            return "play"
        }
    }
    
    var startDoneButtonText: String {
        switch item.status {
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
        case .completed:
            return .red
        case .started:
            return .blue
        case .unstarted:
            return .secondaryBackground
        }
    }
    
    var startDoneButtonForegroundColor: Color {
        switch item.status {
        case .completed, .started:
            return .white
        case .unstarted:
            return .primary
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
                                    isPropertiesShown = true
                                }) {
                                    HStack {
                                        Text("Edit")
                                        Image(systemName: "pencil")
                                    }
                                }
                                
                                Button(action: {
                                    item.move()
                                }) {
                                    HStack {
                                        Text(item.isInQueue ? "Move to \(language.backlog.title)" : "Move to \(language.queue.title)")
                                        Image(systemName: item.isInQueue ? "arrow.right.to.line" : "arrow.left.to.line")
                                    }
                                }
                                
                                Button(action: {
                                    // TODO delete item
                                }) {
                                    HStack {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }.foregroundColor(.red) // As of February 2020, coloring this doesn't work due to a bug in SwiftUI
                            }
                    }
                    Spacer()
                    if item.isInQueue && !editing {
                        SolidButton(startDoneButtonText, foreground: startDoneButtonForegroundColor, background: startDoneButtonBackgroundColor) {
                            item.status = item.status.next()
                        }
                        .accessibility(identifier: "Complete Item " + item.displayName)
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
                HStack {
                    Text("Edit Item Properties")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 50)
                    Spacer()
                    
                }
                ItemProperties(item) {
                    isPropertiesShown = false
                }
            }
        }
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var basicBacklogItem = DomainItem(name: "Backlog Item")
    static var complexBacklogItem: DomainItem {
        let item = DomainItem(name: "Backlog Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        item.isRepeat = true
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.moveOnRelease = true
        return item
    }
    static var futureBacklogItem: DomainItem {
        let item = DomainItem(name: "Future Backlog Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 6000000000)
        item.isRepeat = true
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.moveOnRelease = true
        return item
    }
    static var completedQueueItem: DomainItem {
        let item = DomainItem(name: "Completed Queue Item")
        item.status = .completed
        item.inQueueOf = Domain(name: "Queue Holder")
        return item
    }
    static var startedQueueItem: DomainItem {
        let item = DomainItem(name: "Started Queue Item")
        item.status = .started
        item.inQueueOf = Domain(name: "Queue Holder")
        return item
    }
    static var unstartedQueueItem: DomainItem {
        let item = DomainItem(name: "Unstarted Queue Item")
        item.inQueueOf = Domain(name: "Queue Holder")
        return item
    }
    static var complexQueueItem: DomainItem {
        let item = DomainItem(name: "Unstarted Queue Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        item.isRepeat = true
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.inQueueOf = Domain(name: "Queue Holder")
        return item
    }
    static var futureQueueItem: DomainItem {
        let item = DomainItem(name: "Future Unstarted Queue Item with properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 6000000000)
        item.isRepeat = true
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.inQueueOf = Domain(name: "Queue Holder")
        return item
    }

    static var previews: some View {
        VStack {
            ItemCardView(item: basicBacklogItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: complexBacklogItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: futureBacklogItem)
                .frame(width: 400)
            Divider()
                .padding()
            ItemCardView(item: completedQueueItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: startedQueueItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: unstartedQueueItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: complexQueueItem)
                .frame(width: 400)
                .padding(.bottom)
            ItemCardView(item: futureQueueItem)
                .frame(width: 400)
                .padding(.bottom)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
