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
    
    var body: some View {
        VStack {
            HStack {
                if item.hasReleaseDate {
                    Image(systemName: "calendar")
                    Text(item.displayDate)
                        .padding(.trailing)
                    Spacer()
                }
                if item.isRepeat {
                    Image(systemName: "repeat")
                        .transition(.identity)
                }
                if item.notes != nil {
                    Image(systemName: "doc.plaintext")
                        .transition(.identity)
                }
            }
            
        }
    }
}

// struct ItemCardIndicatorsView_Previews: PreviewProvider {
//     static var previews: some View {
//         ItemCardIndicatorsView()
//     }
// }
