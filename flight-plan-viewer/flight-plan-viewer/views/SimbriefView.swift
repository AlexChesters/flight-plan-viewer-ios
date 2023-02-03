//
//  SimbriefView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

struct SimbriefView: View {
    @EnvironmentObject var userController: UserController
    @State var flightPlan: FlightPlan?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(userController.simbriefUser.pilotId ?? "Simbrief Pilot ID not set")
            
            Text(flightPlan?.origin ?? "foo")
            
            Spacer()
            
            Divider()
        }
        .task {
            await userController.simbriefUser.fetchLatestFlightPlan() { response in
                flightPlan = response
            }
        }
    }
}

struct SimbriefView_Previews: PreviewProvider {
    static var previews: some View {
        SimbriefView()
    }
}
