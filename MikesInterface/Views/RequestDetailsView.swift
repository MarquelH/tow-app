//
//  DetailsView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/13/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct RequestDetailsView: View {
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var shouldShowActionSheet = false
    @Binding var alert: Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var destinationName: String
    @Binding var sourceName: String
    @Binding var distance: String
    @Binding var shouldShowDetails: Bool
    //@Binding var time: String
    var date: Date
    var towRequest: TowRequest
    var mapViewModel = MapViewModel()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 10) {
                MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, distance: self.distance)
                    .frame(height: geometry.size.height / 2)
                                
                Text("Expected Distance - \(self.distance)  Miles")
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Text("Pickup - \(towRequest.sourceAddress)")
                Text("Dropoff - \(towRequest.destinationAddress)")
                
                Button {
                    shouldShowActionSheet.toggle()
                } label: {
                    Text("Navigate")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 2, alignment: .center)
                }
                .background(Color.green)
                .clipShape(Capsule())
                
                Button {
                    self.shouldShowDetails.toggle()
                } label: {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 2, alignment: .center)
                }
                .background(Color.red)
                .clipShape(Capsule())
            }
        }
        .onAppear {
            UpdateMap()
        }
        .actionSheet(isPresented: $shouldShowActionSheet) {
            ActionSheet(
                title: Text("Navigation"),
                buttons: [
                    .default(Text("Navigate to Pickup Location")) {
                        mapViewModel.openAppleMapsViaUrl(latitude: towRequest.sourceCoordinate.latitude, longitude: towRequest.sourceCoordinate.longitude)
                    },

                    .default(Text("Navigate to Dropoff Location")) {
                        mapViewModel.openAppleMapsViaUrl(latitude: towRequest.destinationCoordinate.latitude, longitude: towRequest.destinationCoordinate.longitude)
                    },
                    
                    .destructive(Text("Cancel"), action: {
                        shouldShowActionSheet.toggle()
                    })
                ]
            )
        }
    }
    
    func UpdateMap() {
        guard let theSource = self.source, let theDestination = self.destination else { return }
        let point = MKPointAnnotation()
        point.subtitle = "Dropoff"
        point.coordinate = theDestination
        
        let otherPoint = MKPointAnnotation()
        otherPoint.subtitle = "Pickup"
        otherPoint.coordinate = theSource
            
        let decoder = CLGeocoder()
        decoder.reverseGeocodeLocation(CLLocation(latitude: theDestination.latitude, longitude: theDestination.longitude)) { (places, err) in
                
            if err != nil {
                print(err?.localizedDescription)
                return
            }
                
            self.destinationName = places?.first?.name ?? ""
            point.title = places?.first?.name ?? ""
                
            //self.detail = true
        }
        
        decoder.reverseGeocodeLocation(CLLocation(latitude: theSource.latitude, longitude: theSource.longitude)) { (places, err) in
                
            if err != nil {
                print(err?.localizedDescription)
                return
            }
                
            self.sourceName = places?.first?.name ?? ""
            otherPoint.title = places?.first?.name ?? ""
                
            //self.detail = true
        }
        
        
            
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: theSource))
            
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: theDestination))
            
        let directions = MKDirections(request: req)
            
        directions.calculate { (dir, err) in
                
            if err != nil{
                    
                print(err?.localizedDescription)
                return
            }
                
            let polyline = dir?.routes[0].polyline
                
            if let dis = dir?.routes[0].distance, let time = dir?.routes[0].expectedTravelTime {
                self.distance = String(format: "%.1f", dis / 1000)
                //self.time = String(format: "%.1f", time / 60)
            }
                
            self.map.removeOverlays(self.map.overlays)
                
            self.map.addOverlay(polyline!)
            
            var regionRect = polyline!.boundingMapRect
            
            var wPadding = regionRect.size.width * 0.25
            var hPadding = regionRect.size.height * 0.25

            //Add padding to the region
            regionRect.size.width += wPadding
            regionRect.size.height += hPadding

            //Center the region on the line
            regionRect.origin.x -= wPadding / 2
            regionRect.origin.y -= hPadding / 2
            self.map.setRegion(MKCoordinateRegion(regionRect), animated: true)
        }
            
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(point)
        self.map.addAnnotation(otherPoint)
    }
}
