//
//  BigText.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 1/26/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//
import SwiftUI

struct BigText: ViewModifier {
    let bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: bold ? .bold : .regular))
    }
}

extension View {
    func bigText(bold: Bool = false) -> some View {
        self.modifier(BigText(bold: bold))
    }
}

struct BigText_Previews: PreviewProvider {
    static var previews: some View {
        Text("This text is big")
            .bigText()
    }
}