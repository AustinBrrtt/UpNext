//
//  DomainsModel.swift
//  UpNext
//
//  Created by Austin Barrett on 6/24/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import Foundation

class DomainsModel: ObservableObject {
    @Published var domains: [Domain] = []
    
    init() {
        self.domains = loadDomains()
    }
    
    func loadDomains() -> [Domain] {
        // TODO: Load domains
        return []
    }
}
