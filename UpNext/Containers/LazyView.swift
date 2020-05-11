//
//  LazyView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 12/27/19.
//  Copyright © 2019 Austin Barrett. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView(Text("Hello"))
    }
}
