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
                    await userController.simbriefUser.fetchLatestFlightPlan() { response in
                        flightPlan = response
                    }
                }
        } else {
            VStack {
                Text("\(flightPlan!.origin) - \(flightPlan!.destination)")
                    .font(.title)
                HStack {
                    Text("\(flightPlan!.flightNumber) / \(flightPlan!.callsign)")
                        .font(.headline)
                }
                
                Divider()
                
                Text("Cost index: \(flightPlan!.costIndex)")
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Spacer()

                Divider()
            }
            .padding()
        }
    }
}

struct SimbriefView_Previews: PreviewProvider {
    static var previews: some View {
        let viewWithoutSimbriefUser = SimbriefView()
        let viewWithFlightPlan = SimbriefView(
            flightPlan: FlightPlan(
                origin: "EGCC",
                destination: "EGJJ",
                costIndex: "54",
                flightNumber: "EZY1354",
                callsign: "EZY69AZ"
            )
        )

        let userControllerWithSimbriefUser = UserController()
        userControllerWithSimbriefUser.simbriefUser.pilotId = "foo"
        
        return Group {
            viewWithoutSimbriefUser
                .environmentObject(UserController())
            viewWithFlightPlan
                .environmentObject(userControllerWithSimbriefUser)
        }
    }
}
