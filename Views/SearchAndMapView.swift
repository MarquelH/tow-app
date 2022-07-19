//
//  SearchView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/9/22.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation
import Firebase

struct SearchAndMapView: View {
    @Binding var map: MKMapView
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    @Binding var source: CLLocationCoordinate2D!
    @Binding var destination: CLLocationCoordinate2D!
    @Binding var destinationName: String
    @Binding var sourceName: String
    @Binding var distance: String
    @Binding var time: String
    @Binding var showTripDetails: Bool
    @Binding var loading: Bool
    @Binding var book: Bool
    @Binding var doc: String
    @Binding var data : Data
    @Binding var search: Bool
    @Binding var tabSelection: Int
    @Binding var hasRequest: Bool
    @Binding var isNewBooking: Bool
    @Binding var user: User
    @Binding var loggedInStatus: Int
    
    @ObservedObject var homeViewModel: HomeViewModel
    var viewModelPublisher: CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>
    
    var body: some View {
        
        GeometryReader{ geometry in
            ZStack {
                
                ZStack(alignment: .bottom){
                    
                    VStack(spacing: 0){
                        
                        HeaderView(search: self.$search, homeViewModel: homeViewModel, loggedInStatus: self.$loggedInStatus)
                            .padding()
                            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                            .background(Color.white)
                        
                        if self.search {
                            Divider()
                            SearchHeaderView(user: self.$user, show: self.$search, map: self.$map, source: self.$source, destination: self.$destination, sourceName: self.$sourceName, destinationName: self.$destinationName, distance: self.$distance, time: self.$time, name: self.$sourceName, detail: self.$showTripDetails, tabSelection: self.$tabSelection, viewModelPublisher: self.viewModelPublisher, homeViewModel: self.homeViewModel, hasRequest: self.$hasRequest, isNewBooking: self.$isNewBooking)
                                .frame(width: geometry.size.width, height: UIScreen.main.bounds.height/5.2, alignment: .top)
                                .padding(.top, 9)
                        }
                        
                        MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, distance: self.distance)
                            .onAppear {
                                print("Appeared with source: \(self.$source)")
                                print("Appeared with dest: \(self.$destination)")
                                self.manager.requestAlwaysAuthorization()
                            }
                    }
                    
                    if self.destination != nil && self.showTripDetails {
                        
                        ZStack(alignment: .topTrailing){
                            
                            VStack(spacing: 20){
                                
                                HStack{
                                    
                                    VStack(alignment: .leading,spacing: 15){
                                        
                                        //Text("Destination")
                                            //.fontWeight(.bold)
                                            
                                        //Text(self.destinationName)
                                        
                                        //Text("Distance - "+self.distance+" KM")
                                        
                                        Text("Expected Distance - \(self.distance)  Miles")
                                            .fontWeight(.bold)
                                            .padding(.bottom)
                                    }
                                    
                                    Spacer()
                                }
                                
                                /*Button(action: {
                                    
                                    self.book = homeViewModel.book(source: self.source, destination: self.destination, distance: self.distance, name: "MarquelForNow")
                                    
                                }) {
                                    
                                    Text("Send Tow Request")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width / 2)
                                }
                                .background(Color.red)
                                .clipShape(Capsule())*/
                            
                            }
                            
                            Button(action: {
                                
                                //self.map.removeOverlays(self.map.overlays)
                                //self.map.removeAnnotations(self.map.annotations)
                                //self.destination = nil
                                
                                self.showTripDetails.toggle()
                                
                            }) {
                                
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                        .background(Color.white)
                    }
                }
                
                if self.loading{
                    Loader()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: self.$alert) { () -> Alert in
                Alert(title: Text("Error"), message: Text("Please Enable Location In Settings !!!"), dismissButton: .destructive(Text("Ok")))
            }
            .onAppear {
                if let userUID = user.userUID {
                    //check if user was updated
                    let docRef = FirebaseManager.shared.firestore.collection("Users").document(userUID)
                    
                    docRef.getDocument(as: User.self) { result in
                        switch result {
                            case .success(let user):
                                print("FOUND USER!")
                            self.user = user
                            case .failure(let error):
                                print("Error decoding user: \(error)")
                        }
                    }
                }
                
                if let userHasRequest = user.hasCurrentReservation {
                    self.hasRequest = userHasRequest
                }
            }
        }
    }
    
}
