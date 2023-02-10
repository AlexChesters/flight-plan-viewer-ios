//
//  RouteMapView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 10/02/2023.
//

import SwiftUI
import MapKit

struct MapLineView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let coordinates: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapLineView

  init(_ parent: MapLineView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
      renderer.strokeColor = UIColor.systemBlue
      renderer.lineWidth = 10
      return renderer
    }
    return MKOverlayRenderer()
  }
}

struct RouteMapView: View {
    let center: CLLocationCoordinate2D
    let waypoints: [Waypoint]
    
    var body: some View {
        MapLineView(
            region: MKCoordinateRegion(
                center: waypoints[0].location,
                span: MKCoordinateSpan(
                    latitudeDelta: 10,
                    longitudeDelta: 10
                )
            ),
            coordinates: waypoints.map { return $0.location }
        )
    }
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            // Brookmans Park
            center: CLLocationCoordinate2D(
                latitude: 51.749736,
                longitude: -0.106736
            ),
            waypoints: [
                // Brookmans Park
                Waypoint(
                    location: CLLocationCoordinate2D(
                        latitude: 51.749736,
                        longitude: -0.106736
                    )
                ),
                // Trent
                Waypoint(
                    location: CLLocationCoordinate2D(
                        latitude: 53.053953,
                        longitude: -1.669969
                    )
                )
            ]
        )
    }
}
