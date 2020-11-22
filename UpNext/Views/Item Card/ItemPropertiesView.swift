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
    var item: DomainItem
    @State var properties: ItemProperties
    
    private var dismiss: () -> Void
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: DomainItem, dismiss: @escaping () -> Void) {
        self.item = item
        self._properties = State(initialValue: ItemProperties(from: item))
        self.dismiss = dismiss
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if item.status != .backlog {
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
                    Toggle(isOn: $properties.useDate) {
                        Text("Show Release Date")
                    }
                    if properties.useDate {
                        DatePicker("Release Date", selection: $properties.date, displayedComponents: .date)
                            .labelsHidden()
                        if item.status == .backlog {
                            Toggle(isOn: $properties.moveOnRelease) {
                                Text("Move to Up Next on Release Date")
                            }.accessibility(identifier: "Add to Queue on Release")
                        }
                    }
                }
                
                Section() {
                    TextEditor(text: $properties.notes)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: false)
                        .accessibility(identifier: "Item Notes")
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
        model.updateItemProperties(on: item, to: properties)
    }
}

struct ItemProperties_Previews: PreviewProvider {
    static var previews: some View {
        return ItemPropertiesView(DomainItem.createMock(name: "Sample Item")) { }
            .environmentObject(DomainsModel())
            .previewLayout(.fixed(width: 450, height: 350))
    }
}
