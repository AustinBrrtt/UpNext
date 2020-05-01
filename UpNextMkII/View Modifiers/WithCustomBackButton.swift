//
//  CustomBackButton.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 4/30/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

extension View {
    func withCustomBackButton<Content: View>(_ content: Content, showChevron: Bool = true, goBack: @escaping () -> Void) -> some View {
        withCustomBackButton(content, andTrailingItem: EmptyView(), showChevron: showChevron, goBack: goBack)
    }
    
    func withCustomBackButton<Content: View, TrailingItem: View>(_ content: Content, andTrailingItem trailingItem: TrailingItem, showChevron: Bool = true, goBack: @escaping () -> Void) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton(showChevron: showChevron, content: content, goBack: goBack), trailing: trailingItem)
            .gesture(DragGesture().onEnded { (value) in
                if value.startLocation.x < 20 && value.translation.width > 100 {
                    goBack()
                }
            })
    }
}
