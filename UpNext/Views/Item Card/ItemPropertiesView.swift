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
    let type: ItemListType
    
    private var dismiss: () -> Void
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: Binding<DomainItem>, type: ItemListType, dismiss: @escaping () -> Void) {
        self._item = item
        self._properties = State(initialValue: ItemProperties(from: item.wrappedValue))
        self.dismiss = dismiss
        self.type = type
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if type == .queue {
                        Picker("Status", selection: $properties.status) {
                            Text("Unstarted")
                                .accessibility(identifier: "Unstarted Segment")
                                .tag(ItemStatus.unstarted)
                            Text("Started")
                                .accessibility(identifier: "Started Segment")
                                .tag(ItemStatus.started)
                            Text("Completed")
                                .accessibility(identifier: "Completed Segment")
                                .tag(ItemStatus.completed)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    TextField(language.itemTitle.title, text: $properties.title)
                        .autocapitalization(.words)
                        .clearButton(text: $properties.title)
                        .bigText()
                        .accessibility(identifier: "Item Title")
                }
                
                Section {
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
                        if type == .backlog {
                            Toggle(isOn: $properties.moveOnRelease) {
                                Text("Move to \(language.queue.title) on Release Date")
                            }.accessibility(identifier: "Add to Queue on Release")
                        }
                    }
                }
                
                Section() {
                    MultilineTextField("Notes", text: $properties.notes, accessibilityIdentifier: "Item Notes")
//                    TextEditor(text: $properties.notes)
//                        .lineLimit(nil)
//                        .fixedSize(horizontal: false, vertical: false)
//                        .accessibility(identifier: "Item Notes")
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveFields()
                    dismiss()
                }
            )
        }
    }
    
    private func saveFields() {
        item.name = properties.title.trimmingCharacters(in: .whitespaces)
        item.status = properties.status
        item.notes = properties.notes.count > 0 ? properties.notes : nil
        item.isRepeat = properties.isRepeat
        item.releaseDate = properties.useDate ? properties.date : nil
        item.moveOnRelease = properties.moveOnRelease
    }
}

struct ItemProperties_Previews: PreviewProvider {
    static var previews: some View {
        return ItemPropertiesView(.constant(DomainItem(name: "Sample Item")), type: .backlog) { }
            .environmentObject(DomainsModel())
            .previewLayout(.fixed(width: 450, height: 350))
    }
}
