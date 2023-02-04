//
//  SimbriefView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

fileprivate struct NoUserView: View {
    var body: some View {
        VStack {
            Text("Simbrief Pilot ID has not been set (enter this in the Settings tab)")
        }
    }
}

struct SimbriefView: View {
    @EnvironmentObject var userController: UserController
    @State var flightPlan: FlightPlan?
    
    @ViewBuilder
    var body: some View {
        if userController.simbriefUser.pilotId == nil {
            NoUserView()
        } else {
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
}

struct SimbriefView_Previews: PreviewProvider {
    static var previews: some View {
        let userController = UserController()
        let userControllerWithPilotIdSet = UserController()
        userControllerWithPilotIdSet.simbriefUser.pilotId = "Sully Sullenberger"
        
        return Group {
            SimbriefView().environmentObject(userController)
            SimbriefView().environmentObject(userControllerWithPilotIdSet)
        }
    }
}
