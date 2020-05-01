//
//  CustomBackButton.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 4/30/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct CustomBackButton<Content: View>: View {
    let showChevron: Bool
    let content: Content
    let goBack: () -> Void
    
    var body: some View {
        Button(action: goBack) {
            HStack {
                if showChevron {
                    Image(systemName: "chevron.left")
                }
                content
            }
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton(showChevron: true, content: Text("Foo")) {
            print("going back")
        }
    }
}
