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
    @State var properties: ItemProperties
    let item: DomainItem?
    let domain: Domain
    
    private var dismiss: () -> Void
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(_ item: DomainItem, domain: Domain, dismiss: @escaping () -> Void) {
        self.item = item
        self._properties = State(initialValue: ItemProperties(from: item))
        self.dismiss = dismiss
        self.domain = domain
    }
    
    init(prequel: DomainItem, domain: Domain, dismiss: @escaping () -> Void) {
        let name = "" // TODO: #175924619
        self._properties = State(
            initialValue: ItemProperties(
                title: name,
                status: .unstarted,
                notes: prequel.notes,
                releaseDate: nil,
                moveOnRelease: false,
                seriesName: prequel.seriesName
            )
        )
        self.dismiss = dismiss
        self.domain = domain
        self.item = nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Status", selection: $properties.status) {
                        Text("Backlog")
                            .accessibility(identifier: "Unstarted Segment")
                            .tag(ItemStatus.backlog)
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
                    
                    TextField(language.itemTitle.title, text: $properties.title)
                        .autocapitalization(.words)
                        .clearButton(text: $properties.title)
                        .bigText()
                        .accessibility(identifier: "Item Title")
                }
                
                Section {
                    Toggle(isOn: $properties.inSeries) {
                        Text("Part of a Series")
                    }
                    
                    if properties.inSeries {
                        TextField("Series Name", text: $properties.seriesName)
                            .autocapitalization(.words)
                            .clearButton(text: $properties.seriesName)
                            .accessibility(identifier: "Series Name")
                    }
                }
                
                Section {
                    Toggle(isOn: $properties.useDate) {
                        Text("Show Release Date")
                    }
                    
                    if properties.useDate {
                        DatePicker("Release Date", selection: $properties.date, displayedComponents: .date)
                            .labelsHidden()
                        if properties.status == .backlog {
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
            .navigationBarTitle(item == nil ? "Add Next in Series" : "Edit Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }.foregroundColor(.accentColor),
                trailing: Button(item == nil ? "Add Item" : "Save") {
                    saveFields()
                    dismiss()
                }.foregroundColor(.accentColor)
            )
        }
    }
    
    private func saveFields() {
        let item = self.item ?? model.addItem(name: properties.title, in: properties.status, of: domain)
        model.updateItemProperties(on: item, to: properties)
    }
}

struct ItemProperties_Previews: PreviewProvider {
    static var previews: some View {
        return ItemPropertiesView(DomainItem.createMock(name: "Sample Item"), domain: Domain.createMock()) { }
            .environmentObject(DomainsModel())
            .previewLayout(.fixed(width: 450, height: 350))
    }
}
