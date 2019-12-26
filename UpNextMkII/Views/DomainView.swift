//
//  DomainView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/24/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var domain: Domain
    
    var body: some View {
        VStack {
            AddByNameField("Add Item") { (name: String) in
                let item = DomainItem.create(context: self.managedObjectContext, name: name)
                self.domain.addToQueue(item)
            }
            .padding()
            ItemList(items: domain.queue)
        }
        .navigationBarTitle(domain.name ?? "Untitled")
        .navigationBarItems(trailing: EditButton())
    }
}

struct DomainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO") // todo: CoreData in preview
    }
}
