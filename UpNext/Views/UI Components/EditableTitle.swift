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
    var saveTitle: (String) -> Void
    let language = DomainSpecificLanguage.defaultLanguage
    
    init(title: String, saveTitle: @escaping (String) -> Void) {
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
                        title = title.trimmingCharacters(in: .whitespaces)
                        saveTitle(title)
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
        VStack {
            VStack  {
                Text("Edit Mode off:")
                    .font(.headline)
                EditableTitle(title: "Games") { _ in }
                    .environment(\.editMode, .constant(EditMode.inactive))
            }
            .padding()
            .border(Color.black)
            .padding(.bottom)
            VStack  {
                Text("Edit Mode on:")
                    .font(.headline)
                EditableTitle(title: "Games") { _ in }
                    .environment(\.editMode, .constant(EditMode.active))
            }
            .padding()
            .border(Color.black)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
