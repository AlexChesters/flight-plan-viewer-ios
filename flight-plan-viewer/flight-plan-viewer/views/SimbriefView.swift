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
        } else if flightPlan == nil {
            ProgressView()
                .task {
                    print("hi")
                    await userController.simbriefUser.fetchLatestFlightPlan() { response in
                        flightPlan = response
                    }
                }
        } else {
            VStack {
                Text("\(flightPlan!.origin) - \(flightPlan!.destination)")
                
                Spacer()
                
                Divider()
            }
        }
    }
}

struct SimbriefView_Previews: PreviewProvider {
    static var previews: some View {
        let viewWithoutSimbriefUser = SimbriefView()
        let viewWithFlightPlan = SimbriefView()

        let userControllerWithSimbriefUser = UserController()
        userControllerWithSimbriefUser.simbriefUser.pilotId = "foo"
        viewWithFlightPlan.flightPlan = FlightPlan(
            origin: "EGCC",
            destination: "EGJJ"
        )
        
        return Group {
            viewWithoutSimbriefUser.environmentObject(UserController())
            // TODO: why does this not preview properly?
            viewWithFlightPlan.environmentObject(userControllerWithSimbriefUser)
        }
    }
}
