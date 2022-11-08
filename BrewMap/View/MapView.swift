//
//  MapView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-03.
//

import SwiftUI
import MapKit

struct MapView: View {
    var location: String = ""
    var interactionModes: MapInteractionModes = .all
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
    }
    
    @State private var annotatedItem: AnnotatedItem = AnnotatedItem(coordinate
    : CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773))
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: interactionModes, annotationItems: [annotatedItem]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .task {
            convertAddress(location: location)
        }
    }
    
    private func convertAddress(location: String) {
        // Get location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,
                  let location = placemarks[0].location else {
                return
            }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            
            self.annotatedItem = AnnotatedItem(coordinate: location.coordinate)
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: "152 Wintermute Crt, Belmont, ON, N0L 1B0, CANADA")
    }
}
