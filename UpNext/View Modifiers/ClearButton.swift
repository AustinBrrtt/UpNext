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
                        text = ""
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

struct ClearButton_Previews: PreviewProvider {
    static var previews: some View {
        let text = State<String>(initialValue: "Filled Text Field")
        let emptyText = State<String>(initialValue: "")
        return VStack {
            TextField("Initially Filled Text Field", text: text.projectedValue)
                .clearButton(text: text.projectedValue)
                .padding(.bottom)
            TextField("Empty Text Field", text: emptyText.projectedValue)
                .clearButton(text: emptyText.projectedValue)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
