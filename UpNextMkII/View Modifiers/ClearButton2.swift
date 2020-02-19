//
//  ClearButton.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 2/19/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .accessibility(identifier: "Clear Text")
                    .onTapGesture {
                        self.text = ""
                    }
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> ModifiedContent<Self, ClearButton> {
        return modifier(ClearButton(text: text))
    }
}
