//
//  ConditionalBackground.swift
//  UpNext
//
//  Created by Austin Barrett on 5/11/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

extension View {
    func background<BackgroundType : View>(_ background: BackgroundType, if condition: Bool) -> some View {
        condition ? AnyView(self.background(background)) : AnyView(self)
    }
}

struct ConditionalBackgrond_Previews: PreviewProvider {
    static var previews: some View {
        return VStack {
            Text("Condition is true")
                .padding()
                .background(Color.secondaryBackground, if: true)
            Text("Condition is false")
                .padding()
                .background(Color.secondaryBackground, if: false)
        }
        .previewLayout(.sizeThatFits)
    }
}
