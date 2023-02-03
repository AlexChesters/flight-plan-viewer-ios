//
//  HomeView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(userController.simbriefUser.pilotId ?? "Simbrief Pilot ID not set")
            
            Spacer()
            
            Divider()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
