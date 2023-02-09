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

fileprivate struct Header: View {
    let flightPlan: FlightPlan
    
    var body: some View {
        HStack {
            Image(systemName: "airplane.departure")
            Text("\(flightPlan.origin.code) - \(flightPlan.destination.code)")
                .font(.title)
            Image(systemName: "airplane.arrival")
        }
        
        Text("\(flightPlan.origin.name) - \(flightPlan.destination.name)").italic()
        
        Spacer().frame(maxHeight: 20)
        
        HStack {
            Image(systemName: "airplane")
            Text("\(flightPlan.flightNumber) / \(flightPlan.callsign)")
                .font(.headline)
            Image(systemName: "headphones")
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
                Header(flightPlan: flightPlan!)
                
                Divider()
                
                Spacer().frame(maxHeight: 15)
                
                HStack {
                    VStack {
                        Text("ZFW:")
                            .frame(maxWidth: 70, alignment: .leading)
                        Text("LW:")
                            .frame(maxWidth: 70, alignment: .leading)
                        Text("Payload:")
                            .frame(maxWidth: 70, alignment: .leading)
                    }
                    VStack {
                        Text(verbatim: "\(flightPlan!.zeroFuelWeight) \(flightPlan!.weightUnits.rawValue)")
                        Text(verbatim: "\(flightPlan!.landingWeight) \(flightPlan!.weightUnits.rawValue)")
                        Text(verbatim: "\(flightPlan!.payloadWeight) \(flightPlan!.weightUnits.rawValue)")
                    }
                    
                    VStack {
                        Text("Cost index:")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("Cruising altitude:")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    VStack {
                        Text("\(flightPlan!.costIndex)")
                            .frame(maxWidth: 50, alignment: .trailing)
                        Text("\(flightPlan!.cruisingAltitude)")
                            .frame(maxWidth: 50, alignment: .trailing)
                    }
                }

                Spacer().frame(maxHeight: 30)
                
                HStack {
                    VStack {
                        Text(verbatim: "foo")
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
                zeroFuelWeight: 28292,
                landingWeight: 29751,
                payloadWeight: 7592,
                taxiFuel: 136,
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
