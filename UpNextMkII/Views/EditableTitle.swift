//
//  EditableTitle.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/18/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct EditableTitle: View {
    @Environment(\.editMode) var editMode
    @State var title: String
    var saveTitle: (String) -> Bool
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(title: String, saveTitle: @escaping (String) -> Bool) {
        self._title = State(initialValue: title)
        self.saveTitle = saveTitle
    }
    
    var body: some View {
        HStack {
            if editMode?.wrappedValue == .active {
                TextField(language.domainTitle.title, text: $title)
                    .autocapitalization(.words)
                    .clearButton(text: $title)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .onDisappear {
                        self.title = self.title.trimmingCharacters(in: .whitespaces)
                        _ = self.saveTitle(self.title)
                    }
                    .accessibility(identifier: "Domain Title")
            }
            if editMode?.wrappedValue != .active {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

struct EditableTitle_Previews: PreviewProvider {
    static var previews: some View {
        EditableTitle(title: "Games") {_ in
            return true
        }
    }
}
