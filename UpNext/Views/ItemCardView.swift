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
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editMode
    let language = DomainSpecificLanguage.defaultLanguage
    @State var isPropertiesShown: Bool = false
    @State var expanded: Bool = false
    
    var item: DomainItem
    @Binding var dirtyHack: Bool
    
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
                                    item.move(context: context)
                                    dirtyHack.toggle()
                                }) {
                                    HStack {
                                        Text(item.isInQueue ? "Move to \(language.backlog.title)" : "Move to \(language.queue.title)")
                                        Image(systemName: item.isInQueue ? "arrow.right.to.line" : "arrow.left.to.line")
                                    }
                                }
                                
                                Button(action: {
                                    context.delete(item)
                                    saveCoreData()
                                    dirtyHack.toggle()
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
                            saveCoreData()
                            dirtyHack.toggle()
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
                        .onDisappear {
                            dirtyHack.toggle()
                        }
                    Spacer()
                    
                }
                ItemProperties(item) {
                    isPropertiesShown = false
                    do {
                        try context.save()
                    } catch {
                        print("Saving Failed") // TODO: Remove CoreData
                    }
                    dirtyHack.toggle()
                }
            }
        }
    }
    
    private func saveCoreData() {
        do {
            try context.save()
            dirtyHack.toggle()
        } catch let error as NSError {
            // TODO: Handle CoreData save error
            print("Saving failed. \(error), \(error.userInfo)")
        }
    }
}

// struct ItemCardView_Previews: PreviewProvider {
//     static var previews: some View {
//         ItemCardView(item: )
//     }
// }
