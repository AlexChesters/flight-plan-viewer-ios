//
//  SimbriefAPI.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 03/02/2023.
//

import Foundation

struct SimbriefAPIAirportInfo: Decodable {
    let icao_code: String
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
}

class SimBriefAPIFlightPlan: Decodable {
    let origin: SimbriefAPIAirportInfo
    let destination: SimbriefAPIAirportInfo
    let general: SimbriefAPIGeneralInfo
    let atc: SimbriefAPIAtcInfo
}
