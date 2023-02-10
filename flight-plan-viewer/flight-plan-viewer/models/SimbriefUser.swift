//
//  SimbriefUser.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import Foundation
import Alamofire
import Mocker
import CoreLocation

let simbriefUrl = "https://www.simbrief.com/api/xml.fetcher.php?username=shermheadryder&json=1"

public final class MockData {
    public static let simbriefFlightPlan: URL = Bundle(for: MockData.self).url(forResource: "simbrief-flight-plan", withExtension: "json")!
}

struct Airport {
    let code: String
    let name: String
}

struct Waypoint {
    let name: String
    let location: CLLocationCoordinate2D
}

struct PerformanceInfo {
    let costIndex: String
    let cruisingAltitude: String
    let weightUnits: WeightUnit
    let zeroFuelWeight: Int
    let landingWeight: Int
    let payloadWeight: Int
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
    let waypoints: [Waypoint]
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
            
            let performanceInfo = PerformanceInfo(
                costIndex: results.general.costIndex,
                cruisingAltitude: "FL\(results.atc.cruisingAltitude)",
                weightUnits: results.params.units,
                zeroFuelWeight: Int(results.weights.zeroFuelWeight) ?? 0,
                landingWeight: Int(results.weights.landingWeight) ?? 0,
                payloadWeight: Int(results.weights.payloadWeight) ?? 0
            )
            
            let fuelInfo = FuelInfo(
                taxiFuel: Int(results.fuel.taxiFuel) ?? 0,
                tripFuel: Int(results.fuel.tripFuel) ?? 0,
                contingencyFuel: Int(results.fuel.contingencyFuel) ?? 0,
                alternateFuel: Int(results.fuel.alternateFuel) ?? 0,
                reserveFuel: Int(results.fuel.reserveFuel) ?? 0,
                additionalFuel: Int(results.fuel.additionalFuel) ?? 0,
                minimumTakeOffFuel: Int(results.fuel.minimumTakeOffFuel) ?? 0
            )
            
            let atcInfo = ATCInfo(
                flightNumber: "\(results.general.airline)\(results.general.flightNumber)",
                callsign: results.atc.callsign
            )
            
            let routeInfo = RouteInfo(
                waypoints: results.navlog.waypoints
                    .map {
                        return Waypoint(
                            name: $0.name.capitalized,
                            location: CLLocationCoordinate2D(latitude: Double($0.latitude)!, longitude: Double($0.longitude)!)
                        )
                    }
                    .filter {
                        let namesToIgnore = ["Top Of Climb", "Top Of Descent"]
                        return !namesToIgnore.contains($0.name)
                    }
            )
            
            let flightPlan = FlightPlan(
                origin: origin,
                destination: destination,
                performanceInfo: performanceInfo,
                fuelInfo: fuelInfo,
                atcInfo: atcInfo,
                routeInfo: routeInfo
            )
            completionHandler(flightPlan)
        }
    }
}
