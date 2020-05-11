//
//  ItemCardView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 5/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemCardView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let language = DomainSpecificLanguage.defaultLanguage
    @State var isPropertiesLinkActivated: Bool = false
    
    var item: DomainItem
    @Binding var dirtyHack: Bool
    
    var body: some View {
        NavigationLink(destination: ItemProperties(item, dirtyHack: self.$dirtyHack), isActive: $isPropertiesLinkActivated) {
            HStack {
                if item.isInQueue {
                    Image(systemName: item.completed ? "largecircle.fill.circle" : "circle")
                        .accessibility(identifier: "Complete Item " + item.displayName)
                        .onTapGesture {
                            self.item.completed.toggle()
                            self.saveCoreData()
                            self.dirtyHack.toggle()
                        }
                }
                Text(item.displayName)
                    .listItem()
                    .contextMenu {
                        Button(action: {
                            self.isPropertiesLinkActivated = true
                        }) {
                            HStack {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                        }
                        
                        Button(action: {
                            self.item.move(context: self.managedObjectContext)
                            self.dirtyHack.toggle()
                        }) {
                            HStack {
                                Text(item.isInQueue ? "Move to \(self.language.backlog.title)" : "Move to \(self.language.queue.title)")
                                Image(systemName: item.isInQueue ? "arrow.right.to.line" : "arrow.left.to.line")
                            }
                        }
                        
                        Button(action: {
                            self.managedObjectContext.delete(self.item)
                            self.saveCoreData()
                            self.dirtyHack.toggle()
                        }) {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }.foregroundColor(.red) // As of February 2020, coloring this doesn't work due to a bug in SwiftUI
                }
            }
            .foregroundColor(item.hasFutureReleaseDate ? .secondary : .primary)
        }
    }
    
    private func saveCoreData() {
        do {
            try managedObjectContext.save()
            self.dirtyHack.toggle()
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
