//
//  SimbriefUser.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import Foundation
import Alamofire

struct FlightPlan {
    let origin: String
    let destination: String
}

class SimbriefUser {
    var pilotId: String?
    
    init() {
        refreshPilotId()
    }
    
    // MARK: public functions
    
    public func refreshPilotId () {
        let defaults = UserDefaults.standard
        
        guard let simbriefUsernameFromDefaults = defaults.string(forKey: "username.simbrief") else { return }
        
        pilotId = simbriefUsernameFromDefaults
    }
    
    public func fetchLatestFlightPlan (completionHandler: @escaping (_ result: FlightPlan) -> Void) async {
        let url = "https://www.simbrief.com/api/xml.fetcher.php?username=shermheadryder&json=1"
        
        AF.request(url).responseDecodable(of: SimBriefAPIFlightPlan.self) { response in
            guard let results = response.value else {
                debugPrint(response)
                return
            }
            
            let flightPlan = FlightPlan(
                origin: results.origin.icao_code,
                destination: results.destination.icao_code
            )
            completionHandler(flightPlan)
        }
    }
}
