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
    @State var titleField: String = ""
    var title: String
    var saveTitle: (String) -> Bool
    var body: some View {
        HStack {
            if editMode?.wrappedValue == .active {
                TextField("Title", text: $titleField)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .onDisappear {
                        self.titleField = self.titleField.trimmingCharacters(in: .whitespaces)
                        _ = self.saveTitle(self.titleField)
                        
                    }
            }
            if editMode?.wrappedValue != .active {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .onAppear {
                        if self.titleField == "" {
                            self.titleField = self.title
                        }
                    }
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
