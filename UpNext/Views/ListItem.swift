//
//  ListItem.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/26/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ListItem: ViewModifier {
    let bold: Bool
    
    func body(content: Content) -> some View {
        content
            .bigText(bold: bold)
            .padding(.vertical)
    }
}

extension View {
    func listItem(bold: Bool = false) -> some View {
        modifier(ListItem(bold: bold))
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("Lol")
            .listItem()
    }
}
