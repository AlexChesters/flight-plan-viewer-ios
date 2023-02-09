//
//  SimbriefUser.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import Foundation
import Alamofire
import Mocker

let simbriefUrl = "https://www.simbrief.com/api/xml.fetcher.php?username=shermheadryder&json=1"

public final class MockData {
    public static let simbriefFlightPlan: URL = Bundle(for: MockData.self).url(forResource: "simbrief-flight-plan", withExtension: "json")!
}

struct Airport {
    let code: String
    let name: String
}

struct FlightPlan {
    // location info
    let origin: Airport
    let destination: Airport
    
    // perf info
    let costIndex: String
    let cruisingAltitude: String
    let weightUnits: WeightUnit
    let zeroFuelWeight: Int
    let landingWeight: Int
    let payloadWeight: Int
    
    // atc info
    let flightNumber: String
    let callsign: String
    
}

class SimbriefUser {
    var pilotId: String?
    private let sessionManager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        sessionManager = Alamofire.Session(configuration: configuration)
        
        refreshPilotId()
    }
    
    // MARK: public functions
    
    public func refreshPilotId () {
        let defaults = UserDefaults.standard
        
        guard let simbriefUsernameFromDefaults = defaults.string(forKey: "username.simbrief") else { return }
        
        pilotId = simbriefUsernameFromDefaults
    }
    
    public func fetchLatestFlightPlan (completionHandler: @escaping (_ result: FlightPlan) -> Void) async {
        let mock = Mock(url: URL(string: simbriefUrl)!, dataType: .json, statusCode: 200, data: [
            .get: try! Data(contentsOf: MockData.simbriefFlightPlan)
        ])
        mock.register()
        
        sessionManager.request(simbriefUrl).responseDecodable(of: SimBriefAPIFlightPlan.self) { response in
            guard let results = response.value else {
                debugPrint(response)
                return
            }
            
            let origin = Airport(code: results.origin.icaoCode, name: results.origin.name)
            let destination = Airport(code: results.destination.icaoCode, name: results.destination.name)
            
            let flightPlan = FlightPlan(
                origin: origin,
                destination: destination,
                costIndex: results.general.costIndex,
                cruisingAltitude: "FL\(results.atc.cruisingAltitude)",
                weightUnits: results.params.units,
                zeroFuelWeight: Int(results.weights.zeroFuelWeight) ?? 0,
                landingWeight: Int(results.weights.landingWeight) ?? 0,
                payloadWeight: Int(results.weights.payloadWeight) ?? 0,
                flightNumber: "\(results.general.airline)\(results.general.flightNumber)",
                callsign: results.atc.callsign
            )
            completionHandler(flightPlan)
        }
    }
}
