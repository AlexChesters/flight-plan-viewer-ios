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
                Text("\(flightPlan!.origin.code) - \(flightPlan!.destination.code)")
                    .font(.title)
                Text("\(flightPlan!.origin.name) - \(flightPlan!.destination.name)").italic()
                
                Spacer().frame(maxHeight: 20)
                
                HStack {
                    Image(systemName: "airplane")
                    Text("\(flightPlan!.flightNumber) / \(flightPlan!.callsign)")
                        .font(.headline)
                    Image(systemName: "headphones")
                }
                
                Divider()
                
                Spacer().frame(maxHeight: 15)
                
                HStack() {
                    VStack {
                        Text("Cost index: \(flightPlan!.costIndex)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("Cruising altitude: \(flightPlan!.cruisingAltitude)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

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
                origin: Airport(
                    code: "EGCC",
                    name: "Manchester"
                ),
                destination: Airport(
                    code: "EGLC",
                    name: "London City"
                ),
                costIndex: "54",
                cruisingAltitude: "FL180",
                weightUnits: .kgs,
                flightNumber: "BAW143",
                callsign: "SHT4L"
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
