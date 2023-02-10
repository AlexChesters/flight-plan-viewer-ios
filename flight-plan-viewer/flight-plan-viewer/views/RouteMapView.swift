//
//  RouteMapView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 10/02/2023.
//

import SwiftUI
import MapKit

struct RouteMapView: View {
    let center: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.507222,
            longitude: -0.1275
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
            .frame(width: .infinity, height: .infinity)
            .onAppear {
                region.center = center
            }
    }
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            center: CLLocationCoordinate2D(
                latitude: 51.749736,
                longitude: -0.106736
            )
        )
    }
}
