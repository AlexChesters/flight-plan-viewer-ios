//
//  SimbriefView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI
import MapKit

fileprivate struct NoUserView: View {
    var body: some View {
        VStack {
            Text("Simbrief Pilot ID has not been set (enter this in the Settings tab)")
        }
    }
}

fileprivate struct FlightSummaryView: View {
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
            Text("\(flightPlan.atcInfo.flightNumber) / \(flightPlan.atcInfo.callsign)")
                .font(.headline)
            Image(systemName: "headphones")
        }
    }
}

fileprivate struct PerformanceAndFuelView: View {
    let flightPlan: FlightPlan
    
    var body: some View {
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
                Text(verbatim: "\(flightPlan.performanceInfo.zeroFuelWeight) \(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.performanceInfo.landingWeight) \(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.performanceInfo.payloadWeight) \(flightPlan.performanceInfo.weightUnits.rawValue)")
            }
            
            VStack {
                Text("Cost index:")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("Cruising altitude:")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack {
                Text("\(flightPlan.performanceInfo.costIndex)")
                    .frame(maxWidth: 50, alignment: .trailing)
                Text("\(flightPlan.performanceInfo.cruisingAltitude)")
                    .frame(maxWidth: 50, alignment: .trailing)
            }
        }

        Spacer().frame(maxHeight: 30)
        
        HStack {
            VStack {
                Text("Taxi fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Trip fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Contingency fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Alternate fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Reserve fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Additional fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
                Text("Minimum take-off fuel:")
                    .frame(maxWidth: 200, alignment: .leading)
            }
            VStack {
                Text(verbatim: "\(flightPlan.fuelInfo.taxiFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.tripFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.contingencyFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.alternateFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.reserveFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.additionalFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
                Text(verbatim: "\(flightPlan.fuelInfo.minimumTakeOffFuel)\(flightPlan.performanceInfo.weightUnits.rawValue)")
            }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
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
                FlightSummaryView(flightPlan: flightPlan!)
                
                Divider()
                
                Spacer().frame(maxHeight: 15)
                
                PerformanceAndFuelView(flightPlan: flightPlan!)
                
                Spacer().frame(maxHeight: 30)
                
                RouteMapView(
                    center: flightPlan!.routeInfo.waypoints[0].location,
                    waypoints: flightPlan!.routeInfo.waypoints
                )

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
                performanceInfo: PerformanceInfo(
                    costIndex: "54",
                    cruisingAltitude: "FL180",
                    weightUnits: .kgs,
                    zeroFuelWeight: 28292,
                    landingWeight: 29751,
                    payloadWeight: 7592
                ),
                fuelInfo: FuelInfo(
                    taxiFuel: 136,
                    tripFuel: 1011,
                    contingencyFuel: 140,
                    alternateFuel: 739,
                    reserveFuel: 580,
                    additionalFuel: 0,
                    minimumTakeOffFuel: 2470
                ),
                atcInfo: ATCInfo(
                    flightNumber: "BAW143",
                    callsign: "SHT4L"
                ),
                routeInfo: RouteInfo(
                    waypoints: [
                        Waypoint(
                            name: "Brookmans Park",
                            location: CLLocationCoordinate2D(
                                latitude: 51.749736,
                                longitude: -0.106736
                            )
                        ),
                        Waypoint(
                            name: "Trent",
                            location: CLLocationCoordinate2D(
                                latitude: 53.053953,
                                longitude: -1.669969
                            )
                        )
                    ]
                )
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
