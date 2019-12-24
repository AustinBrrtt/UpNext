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
    @State var newItemName: String = ""
    var domain: Domain
    
    var body: some View {
        VStack {
            HStack {
                TextField("Add Item", text: $newItemName)
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(newItemName == "" ? .secondary : .green)
                    .onTapGesture {
                        if (self.newItemName != "") {
                            let item = DomainItem.create(context: self.managedObjectContext, name: self.newItemName)
                            self.domain.addToQueue(item)
                            
                            do {
                                try self.managedObjectContext.save()
                                self.newItemName = ""
                            } catch let error as NSError {
                                // TODO: Handle CoreData save error
                                print("Saving failed. \(error), \(error.userInfo)")
                            }
                        }
                }
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
