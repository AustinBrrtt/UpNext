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
                        .font(.system(size: 24, weight: .medium))
                        .padding(.horizontal, -4)
                }
                content
            }
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink(
                destination: (
                    VStack {
                        HStack {
                            CustomBackButton(showChevron: true, content: Text("Foo - Custom"), goBack: {})
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                    .navigationBarTitle(Text("Sample"), displayMode: .inline)
                ),
                isActive: .constant(true)
            ) {
                Text("Sample")
            }
            .navigationBarTitle("Foo - System")
        }
    }
}
