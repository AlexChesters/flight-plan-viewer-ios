//
//  SimbriefUser.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import Foundation

struct SimbriefUser {
    var pilotId: String?
    
    init() {
        let defaults = UserDefaults.standard
        
        guard let simbriefUsernameFromDefaults = defaults.string(forKey: "username.simbrief") else { return }
        
        self.pilotId = simbriefUsernameFromDefaults
    }
}
