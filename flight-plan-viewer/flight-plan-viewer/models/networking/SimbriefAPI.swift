//
//  SimbriefAPI.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 03/02/2023.
//

import Foundation

enum WeightUnit: String, Codable {
    case lbs
    case kgs
}

struct SimbriefAPIParamsInfo: Decodable {
    // TODO: test this works with lbs
    let units: WeightUnit
}

struct SimbriefAPIGeneralInfo: Decodable {
    let costIndex: String
    let airline: String
    let flightNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case costIndex = "costindex"
        case airline = "icao_airline"
        case flightNumber = "flight_number"
    }
}

struct SimbriefAPIWeightsInfo: Decodable {
    let zeroFuelWeight: String
    let landingWeight: String
    let payloadWeight: String
    
    private enum CodingKeys: String, CodingKey {
        case zeroFuelWeight = "est_zfw"
        case landingWeight = "est_ldw"
        case payloadWeight = "payload"
    }
}

struct SimbriefAPIFuelInfo: Decodable {
    let taxiFuel: String
    let tripFuel: String
    let contingencyFuel: String
    let alternateFuel: String
    let reserveFuel: String
    let additionalFuel: String
    let minimumTakeOffFuel: String
    
    private enum CodingKeys: String, CodingKey {
        case taxiFuel = "taxi"
        case tripFuel = "enroute_burn"
        case contingencyFuel = "contingency"
        case alternateFuel = "alternate_burn"
        case reserveFuel = "reserve"
        case additionalFuel = "extra"
        case minimumTakeOffFuel = "min_takeoff"
    }
}

struct SimbriefAPIAirportInfo: Decodable {
    let icaoCode: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case icaoCode = "icao_code"
        case name = "name"
    }
}

struct SimbriefAPINavFix: Decodable {
    let latitude: String
    let longitude: String
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "pos_lat"
        case longitude = "pos_long"
    }
}

struct SimbriefAPINavLogInfo: Decodable {
    let waypoints: [SimbriefAPINavFix]
    
    private enum CodingKeys: String, CodingKey {
        case waypoints = "fix"
    }
}

struct SimbriefAPIAtcInfo: Decodable {
    let callsign: String
    let cruisingAltitude: String
    
    private enum CodingKeys: String, CodingKey {
        case callsign = "callsign"
        case cruisingAltitude = "initial_alt"
    }
}

class SimBriefAPIFlightPlan: Decodable {
    let params: SimbriefAPIParamsInfo
    let general: SimbriefAPIGeneralInfo
    let origin: SimbriefAPIAirportInfo
    let destination: SimbriefAPIAirportInfo
    let atc: SimbriefAPIAtcInfo
    let weights: SimbriefAPIWeightsInfo
    let fuel: SimbriefAPIFuelInfo
    let navlog: SimbriefAPINavLogInfo
}
