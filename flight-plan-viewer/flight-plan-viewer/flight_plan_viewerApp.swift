//
//  flight_plan_viewerApp.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

@main
struct flight_plan_viewerApp: App {
    @StateObject private var simbriefUser = SimbriefUser()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(simbriefUser)
        }
    }
}
