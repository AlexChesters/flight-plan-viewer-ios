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
    let waypoints: [Waypoint]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.mapType = .satellite
        
        addLines(to: mapView)
        addAnnotations(to: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func addLines (to mapView: MKMapView) {
        let coordinates = waypoints.map { return $0.location }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    
    private func addAnnotations(to mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = waypoints.map { waypoint -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = waypoint.location
            annotation.title = waypoint.name
            return annotation
        }
        
        mapView.addAnnotations(annotations)
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
      renderer.strokeColor = UIColor.black
      renderer.lineWidth = 3
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
            waypoints: waypoints
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
                Waypoint(
                    name: "Brookmans Park",
                    location: CLLocationCoordinate2D(
                        latitude: 51.749736,
                        longitude: -0.106736
                    )
                ),
                Waypoint(
                    name: "Trent",
                    location: CLLocationCoordinate2D(
                        latitude: 53.053953,
                        longitude: -1.669969
                    )
                )
            ]
        )
    }
}
