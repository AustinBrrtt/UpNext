//
//  ListWithoutSeparator.swift
//  UpNext
//
//  Created by Austin Barrett on 6/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

extension View {
    func withoutSeparators() -> some View {
        self.onAppear {
            UITableView.appearance().separatorStyle = .none
        }
        .onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}
