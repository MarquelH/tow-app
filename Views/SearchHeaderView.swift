//
//  SearchView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/4/22.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

struct SearchHeaderView: View {
    
    @Binding var user: User
    @Binding var show : Bool
    @Binding var map : MKMapView
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var sourceName : String
    @Binding var destinationName : String
    @Binding var distance : String
    @Binding var time : String
    @Binding var name : String
    @State var sourceAutocompleteTxt = ""
    @State var destinationAutocompleteTxt = ""
    @State var sourceTxt : String?
    @State var destinationTxt : String?
    @State var presentingModal = false
    @Binding var detail : Bool
    @State var isSourceSelection = true
    @Binding var tabSelection: Int
    var viewModelPublisher: CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>
    @State private var sourceViewModel = PlaceViewModel(mapItem: nil)
    @State private var destViewModel = PlaceViewModel(mapItem: nil)
    @State var homeViewModel: HomeViewModel
    @Binding var hasRequest: Bool
    @Binding var isNewBooking: Bool

    //@ObservedObject var homeViewModel: HomeViewModel
    
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    
    struct SearchData : Identifiable {
        var id : Int
        var name : String
        var address : String
        var coordinate : CLLocationCoordinate2D
    }
    
    func UpdateMap() {
        guard let theSource = self.source, let theDestination = self.destination else { return }
        let point = MKPointAnnotation()
        point.subtitle = "Destination"
        point.coordinate = theDestination
        
        let otherPoint = MKPointAnnotation()
        otherPoint.subtitle = "Source"
        otherPoint.coordinate = theSource
            
        let decoder = CLGeocoder()
        decoder.reverseGeocodeLocation(CLLocation(latitude: theDestination.latitude, longitude: theDestination.longitude)) { (places, err) in
                
            if err != nil {
                print(err?.localizedDescription)
                return
            }
                
            self.destinationName = places?.first?.name ?? ""
            point.title = places?.first?.name ?? ""
                
            self.detail = true
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
                self.time = String(format: "%.1f", time / 60)
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
    
    var body: some View {
        
        let sourceBinding = Binding<String>(get: {
                    self.sourceName
                }, set: {
                    print("SOURCE BINDING TRIGGERED")
                    self.sourceName = $0
                    self.UpdateMap()
                    print($0)
                    // do whatever you want here
                })
        
        let destinationBinding = Binding<String>(get: {
            self.destinationName
        }, set: {
            print("DEST BINIDNG TRIGGERED")
            self.destinationName = $0
            self.UpdateMap()
            print($0)
            // do whatever you want here
        })
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: 5) {
                    Text("I Need a Tow...")
                        .font(.headline)
                        .frame(alignment: .leading)

                    HStack {
                        Text("From: ")
                            .padding(.leading, 10)
                        
                            TextField("Pickup", text: sourceBinding)
                                .padding(.trailing, 30)
                                .padding(.leading, 5)
                                .textFieldStyle(.roundedBorder)
                                .onTapGesture {
                                    self.presentingModal.toggle()
                                    self.isSourceSelection = true
                                }
                            
                    }
                    .sheet(isPresented: $presentingModal) {
                        SearchAutocompleteView(presentedAsModal: self.$presentingModal, sourceSelection: sourceBinding, destSelection: destinationBinding, isSourceSelection: self.$isSourceSelection, sourceLocation: self.$source, destinationLocation: self.$destination, sourceViewModel: self.$sourceViewModel, destViewModel: self.$destViewModel)
                    }
                    
                    /*
                    if self.sourceTxt != ""{
                        
                        List(self.sourceResult){i in
                            
                            VStack(alignment: .leading){
                                
                                Text(i.name)
                                
                                Text(i.address)
                                    .font(.caption)
                            }
                            .onTapGesture {
                                
                                self.destination = i.coordinate
                                self.UpdateMap()
                                //self.show.toggle()
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height / 3)
                    }*/
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("To: ")
                                .padding(.leading, 10)
                            
                            TextField("Dropoff", text: destinationBinding)
                                .padding(.trailing, 30)
                                .padding(.leading, 5)
                                .textFieldStyle(.roundedBorder)
                                .onTapGesture {
                                    self.presentingModal.toggle()
                                    self.isSourceSelection = false
                                }
                        }
                        .sheet(isPresented: $presentingModal) {
                            SearchAutocompleteView(presentedAsModal: self.$presentingModal, sourceSelection: sourceBinding, destSelection: destinationBinding, isSourceSelection: self.$isSourceSelection, sourceLocation: self.$source, destinationLocation: self.$destination, sourceViewModel: self.$sourceViewModel, destViewModel: self.$destViewModel)
                        }
                        
                        Button(action: {
                            if !self.sourceName.isEmpty && !self.destinationName.isEmpty {
                                self.viewModelPublisher.send((sourceViewModel, destViewModel))
                                self.hasRequest = true
                                self.isNewBooking = true
                                guard let customerId = user.userUID , let customerFirstName = user.firstName, let customerLastName = user.lastName else {
                                    print("NOT USERID OR REAL NAME. CANT STORE")
                                    return
                                }
                                let towRequest = TowRequest(id: "\(UUID())", customerId: customerId, sourceName: self.sourceName, destinationName: self.destinationName, sourceAddress: sourceViewModel.address, destinationAddress: destViewModel.address, sourceCoordinate: self.source, destinationCoordinate: self.destination, distance: self.distance, requestType: "Pending", date: Date.init(), userImageUrl: URL(string: self.user.profileImageUrl!)!, customerFirstName: customerFirstName, customerLastName: customerLastName)
                                if homeViewModel.storeRequest(towRequest: towRequest) == true {
                                    //let the app know that the current user has an updated reservation status
                                    self.user.hasCurrentReservation = homeViewModel.updateUserReservationStatus(user: self.user, newReservationStatus: true)
                                    self.tabSelection = 2
                                }
                            }
                            
                        }) {
                            Text(self.hasRequest ? "Request In Progress" : "Send Tow Request")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width / 2)
                        }
                        .background(self.hasRequest ? Color.gray : Color.red)
                        .clipShape(Capsule())
                        .disabled(self.hasRequest)
                    }
                }
            }
            
        }
        .onAppear {
            if !self.hasRequest {
                //self.sourceName
                self.sourceName = ""
                self.destinationName = ""
            }
        }
        .background(Color.white)
        .clipShape(customCapsuleShape())
    }
    
    
    
    struct customCapsuleShape : Shape {
        
        func path(in rect: CGRect) -> Path {
            
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
            
            return Path(path.cgPath)
        }
    }
}
