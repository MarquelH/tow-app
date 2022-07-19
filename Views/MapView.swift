//
//  MapView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView : UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    
    @Binding var map : MKMapView
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    var distance : String
    
    func makeUIView(context: Context) ->  MKMapView {
        map.delegate = context.coordinator
        manager.delegate = context.coordinator
        map.showsUserLocation = true
        //let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap(ges:)))
        //map.addGestureRecognizer(gesture)
        map.showsTraffic = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        return map
    }
    
    func updateUIView(_ uiView:  MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject,MKMapViewDelegate,CLLocationManagerDelegate {
        
        var parent : MapView
        
        init(parent1 : MapView) {
            
            parent = parent1
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied{
                
                self.parent.alert.toggle()
            }
            else{
                
                self.parent.manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            
            DispatchQueue.main.async { [weak self] in
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                self?.parent.source = location.coordinate
                
                self?.parent.map.region = region
                LocationManager.shared.region = region
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .red
            over.lineWidth = 3
            return over
        }
    }
}
