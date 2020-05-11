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

extension View {
    func onTapDismissesKeyboard() -> some View {
        return onTapGesture {
            dismissKeyboard()
        }
    }
}
