//
//  ConditionalBlur.swift
//  Budge It
//
//  Created by Austin Barrett on 11/23/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

extension View {
    func blur(if condition: Bool, radius: CGFloat, opaque: Bool = false) -> some View {
        return condition ? AnyView(self.blur(radius: radius, opaque: opaque)) : AnyView(self)
    }
}
