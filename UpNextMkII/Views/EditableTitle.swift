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
    
    init(title: String, saveTitle: @escaping (String) -> Bool) {
        self._title = State(initialValue: title)
        self.saveTitle = saveTitle
    }
    
    var body: some View {
        HStack {
            if editMode?.wrappedValue == .active {
                TextField("Title", text: $title)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .onDisappear {
                        self.title = self.title.trimmingCharacters(in: .whitespaces)
                        _ = self.saveTitle(self.title)
                    }
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
