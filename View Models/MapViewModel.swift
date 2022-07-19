//
//  MapViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/22/22.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class MapViewModel: ObservableObject {
    /*var source : CLLocationCoordinate2D
    var destination : CLLocationCoordinate2D
    var sourceName : String
    var destinationName : String
    var distance : String
    var time : String
    var detail : Bool
    var map : MKMapView
    
    init(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, sourceName: String,
         destinationName: String, distance: String, time: String, detail: Bool, map: MKMapView) {
        self.source = source
        self.destination = destination
        self.sourceName = sourceName
        self.destinationName = destinationName
        self.distance = distance
        self.time = time
        self.detail = detail
        self.map = map
    }*/
    
    func openAppleMapsViaUrl(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
}
