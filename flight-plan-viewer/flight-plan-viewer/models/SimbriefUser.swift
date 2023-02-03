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
        refreshPilotId()
    }
    
    // MARK: public functions
    
    public mutating func refreshPilotId () {
        let defaults = UserDefaults.standard
        
        guard let simbriefUsernameFromDefaults = defaults.string(forKey: "username.simbrief") else { return }
        
        pilotId = simbriefUsernameFromDefaults
    }
    
    // MARK: private functions
    
    // TODO: only used for testing,
    private mutating func resetPilotId () {
        UserDefaults.standard.removeObject(forKey: "username.simbrief")
    }
}
