//
//  ItemProperties.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/26/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemProperties: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var item: DomainItem
    @State var title: String
    @Binding var dirtyHack: Bool
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: DomainItem, dirtyHack: Binding<Bool>) {
        self.item = item
        self._title = State(initialValue: item.name ?? "")
        self._dirtyHack = dirtyHack
    }
    
    var body: some View {
        ScrollView {
            TextField(language.itemTitle.title, text: $title)
                .autocapitalization(.words)
                .padding()
                .bigText()
                .accessibility(identifier: "Item Title")
        }
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Cancel")
                    }
                },
                trailing: Button(action: {
                    self.saveFields()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            )
    }
    
    private func saveFields() {
        item.name = title.trimmingCharacters(in: .whitespaces)
        do {
            try managedObjectContext.save()
            dirtyHack.toggle()
        } catch {
            print("Failed to save changes.")
        }
    }
}

struct ItemProperties_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO") // TODO: CoreData previews ItemProperties()
    }
}
