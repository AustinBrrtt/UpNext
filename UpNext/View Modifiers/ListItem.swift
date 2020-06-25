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
            VStack {
                Text("This text is normal")
                    .background(Color.white)
                    .padding(.bottom)
                Text("This text is a list item")
                    .listItem()
                    .background(Color.white)
                    .padding(.bottom)
                Text("This text is a bold list item")
                    .listItem(bold: true)
                    .background(Color.white)
            }
            .padding()
            .background(Color.secondary)
            .previewLayout(.sizeThatFits)
    }
}
