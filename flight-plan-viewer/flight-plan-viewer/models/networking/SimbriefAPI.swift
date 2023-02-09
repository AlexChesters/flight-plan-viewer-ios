//
//  SimbriefAPI.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 03/02/2023.
//

import Foundation

struct SimbriefAPIAirportInfo: Decodable {
    let icaoCode: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case icaoCode = "icao_code"
        case name = "name"
    }
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

struct SimbriefAPIAtcInfo: Decodable {
    let callsign: String
    let cruisingAltitude: String
    
    private enum CodingKeys: String, CodingKey {
        case callsign = "callsign"
        case cruisingAltitude = "initial_alt"
    }
}

class SimBriefAPIFlightPlan: Decodable {
    let origin: SimbriefAPIAirportInfo
    let destination: SimbriefAPIAirportInfo
    let general: SimbriefAPIGeneralInfo
    let atc: SimbriefAPIAtcInfo
}
