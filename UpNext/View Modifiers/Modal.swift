//
//  Modal.swift
//  UpNext
//
//  Created by Austin Barrett on 11/29/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct Modal<Content: View, Host: View>: View {
    @Binding var isPresented: Bool
    let host: Host
    let content: () -> Content
    
    var body: some View {
        ZStack {
            if isPresented {
                VStack {
                    Spacer()
                    content()
                        .padding()
                        .background(Color.secondaryBackground)
                        .cornerRadius(10)
                        .padding()
                    Spacer()
                }
                .background(
                    Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.7)
                        .onTapGesture {
                            isPresented = false
                        }
                )
            }
            
            host.blur(if: !isPresented, radius: 10)
        }
    }
}

extension View {
    func modal<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        return Modal(isPresented: isPresented, host: self, content: content)
    }
}
