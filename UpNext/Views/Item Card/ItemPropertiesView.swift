//
//  ItemPropertiesView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/26/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemPropertiesView: View {
    @EnvironmentObject var model: DomainsModel
    @Binding var item: DomainItem
    @State var properties: ItemProperties
    
    private var dismiss: () -> Void
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: Binding<DomainItem>, dismiss: @escaping () -> Void) {
        self._item = item
        self._properties = State(initialValue: ItemProperties(from: item.wrappedValue))
        self.dismiss = dismiss
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField(language.itemTitle.title, text: $properties.title)
                    .autocapitalization(.words)
                    .clearButton(text: $properties.title)
                    .bigText()
                    .accessibility(identifier: "Item Title")
                
                Toggle(isOn: $properties.isRepeat) {
                    Text("Completed Previously")
                }
                    .accessibility(identifier: "Completed Previously")
                
                Toggle(isOn: $properties.useDate) {
                    Text("Show Release Date")
                }
                if properties.useDate {
                    DatePicker("Release Date", selection: $properties.date, displayedComponents: .date)
                        .labelsHidden()
                    if !model.isItemInQueue(item) {
                        Toggle(isOn: $properties.moveOnRelease) {
                            Text("Move to \(language.queue.title) on Release Date")
                        }.accessibility(identifier: "Add to Queue on Release")
                    }
                }
                
                MultilineTextField("Notes", text: $properties.notes, accessibilityIdentifier: "Item Notes")
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Save") {
                        saveFields()
                        dismiss()
                    }
                }.padding(.vertical)
            }
            .padding()
        }
    }
    
    private func saveFields() {
        item.name = properties.title.trimmingCharacters(in: .whitespaces)
        item.notes = properties.notes.count > 0 ? properties.notes : nil
        item.isRepeat = properties.isRepeat
        item.releaseDate = properties.useDate ? properties.date : nil
        item.moveOnRelease = properties.moveOnRelease
    }
}

struct ItemProperties_Previews: PreviewProvider {
    static var previews: some View {
        return ItemPropertiesView(.constant(DomainItem(name: "Sample Item"))) { }
            .environmentObject(DomainsModel())
            .previewLayout(.fixed(width: 450, height: 350))
    }
}
