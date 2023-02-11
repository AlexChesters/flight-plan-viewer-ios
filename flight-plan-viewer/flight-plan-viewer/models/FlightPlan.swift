//
//  FlightPlan.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import Foundation
import CoreLocation

struct Airport {
    let code: String
    let name: String
    let location: CLLocationCoordinate2D
}

struct Waypoint {
    let name: String
    let location: CLLocationCoordinate2D
    let isSidOrStarWaypoint: Bool
}

struct PerformanceInfo {
    let costIndex: String
    let cruisingAltitude: String
    let weightUnits: WeightUnit
    let zeroFuelWeight: Int
    let landingWeight: Int
    let payloadWeight: Int
    let passengerCount: Int
}

struct FuelInfo {
    let taxiFuel: Int
    let tripFuel: Int
    let contingencyFuel: Int
    let alternateFuel: Int
    let reserveFuel: Int
    let additionalFuel: Int
    let minimumTakeOffFuel: Int
}

struct ATCInfo {
    let flightNumber: String
    let callsign: String
}

struct RouteInfo {
    var waypoints: [Waypoint]
}

struct FlightPlan {
    // location info
    let origin: Airport
    let destination: Airport
    
    let performanceInfo: PerformanceInfo
    let fuelInfo: FuelInfo
    let atcInfo: ATCInfo
    let routeInfo: RouteInfo
}

