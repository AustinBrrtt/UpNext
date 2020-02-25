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
    @State var isRepeat: Bool
    @State var useDate: Bool
    @State var date: Date
    @State var moveOnRelease: Bool
    @Binding var dirtyHack: Bool
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: DomainItem, dirtyHack: Binding<Bool>) {
        self.item = item
        self._title = State(initialValue: item.name ?? "")
        self._isRepeat = State(initialValue: item.isRepeat)
        self._useDate = State(initialValue: item.releaseDate != nil)
        self._date = State(initialValue: item.releaseDate ?? Date())
        self._moveOnRelease = State(initialValue: item.moveOnRelease)
        self._dirtyHack = dirtyHack
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField(language.itemTitle.title, text: $title)
                    .autocapitalization(.words)
                    .clearButton(text: $title)
                    .bigText()
                    .accessibility(identifier: "Item Title")
                
                Toggle(isOn: $isRepeat) {
                    Text("Completed Previously")
                }
                    .accessibility(identifier: "Completed Previously")
                
                Toggle(isOn: $useDate) {
                    Text("Show Release Date")
                }
                if useDate {
                    DatePicker("Release Date", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                    if !item.isInQueue {
                        Toggle(isOn: $moveOnRelease) {
                            Text("Move to \(language.queue.title) on Release Date")
                        }.accessibility(identifier: "Add to Queue on Release")
                    }
                }
            }
            .padding()
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
        item.isRepeat = isRepeat
        item.releaseDate = useDate ? date : nil
        item.moveOnRelease = moveOnRelease
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
