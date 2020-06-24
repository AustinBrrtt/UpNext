//
//  ItemCardIndicatorsView.swift
//  UpNext
//
//  Created by Austin Barrett on 6/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemCardIndicatorsView: View {
    var item: DomainItem
    @Binding var expanded: Bool
    var indicators: [(String, String)]  {
        [
            (item.displayDate, "calendar", item.hasReleaseDate),
            ("Redux", "repeat", item.isRepeat)
        ]
        .filter { $0.2 }
        .map { ($0.0, $0.1) }
    }
    
    var body: some View {
        HStack {
            ForEach(indicators, id: \.0) { indicator in
                if expanded {
                    Label(indicator.0, systemImage: indicator.1)
                        .labelStyle(DefaultLabelStyle())
                        .accentColor(.primary)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .identity))
                } else {
                    Label(indicator.0, systemImage: indicator.1)
                        .labelStyle(IconOnlyLabelStyle())
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .identity))
                }
            }
            Spacer(minLength: 0)
        }
    }
}

// struct ItemCardIndicatorsView_Previews: PreviewProvider {
//     static var previews: some View {
//         ItemCardIndicatorsView()
//     }
// }
