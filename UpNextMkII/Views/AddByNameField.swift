//
//  AddByNameField.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/25/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct AddByNameField: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var name: String = ""
    var addAction: (String) -> Void
    var placeholder: String
    @Binding var dirtyHack: Bool
    
    init(_ placeholder: String, dirtyHack: Binding<Bool>, addAction: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.addAction = addAction
        self._dirtyHack = dirtyHack
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $name)
                .accessibility(identifier: "Add Field")
                .autocapitalization(.words)
            Image(systemName: "plus.circle.fill")
                .foregroundColor(name == "" ? .secondary : .green)
                .onTapGesture {
                    if (self.name != "") {
                        self.addAction(self.name.trimmingCharacters(in: .whitespaces))
                        do {
                           try self.managedObjectContext.save()
                           self.dirtyHack.toggle()
                           self.name = ""
                       } catch let error as NSError {
                           // TODO: Handle CoreData save error
                           print("Saving failed. \(error), \(error.userInfo)")
                       }
                    }
                    dismissKeyboard()
            }
        }
        .bigText()
    }
}

struct AddByNameField_Previews: PreviewProvider {
    static var previews: some View {
        AddByNameField("Add Item", dirtyHack: .constant(true)) { (name: String) in
            print(name)
        }
    }
}
