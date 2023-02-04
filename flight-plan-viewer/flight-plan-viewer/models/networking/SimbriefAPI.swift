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

class SimBriefAPIFlightPlan: Decodable {
    let origin: SimbriefAPIAirport
    let destination: SimbriefAPIAirport
}
