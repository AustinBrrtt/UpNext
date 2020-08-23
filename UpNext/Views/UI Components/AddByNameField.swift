//
//  AddByNameField.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/25/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct AddByNameField: View {
    @State var name: String = ""
    var save: (String) -> Void
    var placeholder: String
    
    init(_ placeholder: String, addAction: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.save = addAction
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $name)
                .autocapitalization(.words)
                .clearButton(text: $name)
            Image(systemName: "plus.circle.fill")
                .foregroundColor(name == "" ? .secondary : .green)
                .onTapGesture {
                    if (name != "") {
                        save(name.trimmingCharacters(in: .whitespaces))
                        name = ""
                    }
                    dismissKeyboard()
            }
        }
        .bigText()
    }
}

struct AddByNameField_Previews: PreviewProvider {
    static var previews: some View {
        AddByNameField("Add Item") { (name: String) in
            print(name)
        }
    }
}
