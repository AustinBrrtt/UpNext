//
//  ListItem.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/26/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ListItem: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bigText()
            .padding(.vertical)
    }
}

extension View {
    func listItem() -> some View {
        self.modifier(ListItem())
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("Lol")
            .listItem()
    }
}
