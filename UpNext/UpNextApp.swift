//
//  UpNextApp.swift
//  UpNext
//
//  Created by Austin Barrett on 7/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

@main
struct UpNextApp: App {
    @StateObject var model: AppModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            DomainList(domains: $model.domains)
                .environmentObject(model)
        }
    }
}
