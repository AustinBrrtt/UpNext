//
//  DismissesKeyboard.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 2/18/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

// This can be used by
func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
}

struct OnTapDismissesKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                dismissKeyboard()
            }
    }
}

extension View {
    func onTapDismissesKeyboard() -> ModifiedContent<Self, OnTapDismissesKeyboard> {
        return modifier(OnTapDismissesKeyboard())
    }
}
