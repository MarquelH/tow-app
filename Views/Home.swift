//
//  Home.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/4/22.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation
import Firebase

struct Home : View {
    
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var destinationName = ""
    @State var sourceName = ""
    @State var distance = ""
    @State var time = ""
    @State var showTripDetails = false
    @State var loading = false
    @State var book = false
    @State var doc = ""
    @State var data : Data = .init(count: 0)
    @State var search = true
    @State var selectedIndex = 1
    @State var isNewBooking = false
    @State var hasRequest = false
    @State var showMenu = false
    
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var user: User
    @Binding var loggedInStatus: Int
    
    let tabBarImages = ["person", "map.fill", "message"]
        
    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
                    NavigationView {
                        Text("Profile")
                            .navigationTitle("Profile")
                    }
                case 1:
                    SearchAndMapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, destinationName: self.$destinationName, sourceName: self.$sourceName, distance: self.$distance, time: self.$time, showTripDetails: self.$showTripDetails, loading: self.$loading, book: self.$book, doc: self.$doc, data: self.$data, search: self.$search, tabSelection: self.$selectedIndex, hasRequest: self.$hasRequest, isNewBooking: self.$isNewBooking, user: self.$user, loggedInStatus: self.$loggedInStatus, homeViewModel: self.homeViewModel, viewModelPublisher: homeViewModel.viewModelPublisher)
                case 2:
                    ChatView(hasRequest: self.$hasRequest, isNewBooking: self.$isNewBooking, hasCurrentReservation: self.$hasRequest, user: self.$user, selectedIndex: self.$selectedIndex, viewModelPublisher: homeViewModel.viewModelPublisher)
                        .onAppear {
                            if !(homeViewModel.viewModelPublisher.value.0?.address.isEmpty ?? false) &&
                                !(homeViewModel.viewModelPublisher.value.1?.address.isEmpty ?? false) {
                                self.hasRequest = true
                            }
                        }
                default:
                    Text("Others")
                }
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<3) { num in
                    Button(action: {
                        selectedIndex = num
                        print("HERE IS USER: \(user)")
                    }, label: {
                        Spacer()
                        Image(systemName: tabBarImages[num])
                            .font(.system(size: selectedIndex == num ? 40 : 24, weight: .bold, design: .monospaced))
                            .foregroundColor(selectedIndex == num ? .red : .gray)
                        Spacer()
                    })
                }
            }
            .background(Color.clear)
        }
    }
}
