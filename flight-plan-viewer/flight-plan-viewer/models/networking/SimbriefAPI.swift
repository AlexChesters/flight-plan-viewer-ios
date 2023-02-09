//
//  SimbriefAPI.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 03/02/2023.
//

import Foundation

struct SimbriefAPIAirport: Decodable {
    let icao_code: String
}

struct SimbriefAPIGeneralInfo: Decodable {
    let costIndex: String
    
    private enum CodingKeys: String, CodingKey {
        case costIndex = "costindex"
    }
}

class SimBriefAPIFlightPlan: Decodable {
    let origin: SimbriefAPIAirport
    let destination: SimbriefAPIAirport
    let general: SimbriefAPIGeneralInfo
}
