//
//  SearchResultsViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/9/22.
//

import Foundation
import MapKit
import Combine

@MainActor
class SearchResultsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $searchText.debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { value in
                if !value.isEmpty && value.count > 3 {
                    self.search(text: value, region: LocationManager.shared.region)
                } else {
                    self.places = []
                }
            }
    }
    
    @Published var places = [PlaceViewModel]()
    @Published var isResponseEmpty = false
    
    func search(text: String, region: MKCoordinateRegion) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if response.mapItems.isEmpty {
                self.isResponseEmpty = true
            } else {
                self.isResponseEmpty = false
            }
            self.places = response.mapItems.map(PlaceViewModel.init)
        }
    }
}

struct PlaceViewModel: Identifiable, Hashable {
    
    var id = UUID()
    private var mapItem: MKMapItem?
    
    init(mapItem: MKMapItem?) {
        self.mapItem = mapItem
    }
    
    var name: String {
        var name = ""
        if let theMapItem = mapItem {
            name = theMapItem.name ?? ""
        }
        return name
    }
    
    var address: String {
        var address = ""
        if let theMapItem = mapItem {
            address = theMapItem.placemark.fullLocationAddress
        }
        return address
    }
    
    var coordinate: CLLocationCoordinate2D {
        var coordinate = CLLocationCoordinate2D()
        if let theMapItem = mapItem {
            coordinate = theMapItem.placemark.coordinate
        }
        return coordinate
    }
    
    var isSelected = false
    
}
