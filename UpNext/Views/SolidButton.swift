//
//  SolidButton.swift
//  UpNext
//
//  Created by Austin Barrett on 6/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct SolidButton: View {
    let label: String
    let foreground: Color
    let background: Color
    let action: () -> Void
    
    init(_ label: String, foreground: Color = .primary, background: Color = .secondaryBackground, action: @escaping () -> Void = {}) {
        self.label = label
        self.foreground = foreground
        self.background = background
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .bold()
                .foregroundColor(foreground)
                .padding(10)
        }
        .buttonStyle(BorderlessButtonStyle()) // Makes it work inside Lists without taking over the list tap gesture
        .background(background)
        .cornerRadius(10)
    }
}

struct SolidButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SolidButton("Finish")
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
