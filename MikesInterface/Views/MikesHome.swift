//
//  MikesHome.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 5/19/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MikesHome: View {
    @State var selectedIndex = 0
    @Binding var user: User
    @Binding var loggedInStatus: Int
    var homeViewModel = HomeViewModel()
    
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    
    let tabBarImages = ["list.dash", "gearshape"]
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
                    RequestListView(loggedInStatus: $loggedInStatus, homeViewModel: homeViewModel)
                case 1:
                    NavigationView {
                        Text("Settings?")
                            .navigationTitle("Settings")
                    }
                    
                default:
                    Text("Others")
                }
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<2) { num in
                    Button(action: {
                        selectedIndex = num
                        print("HERE IS USER: \(user)")
                    }, label: {
                        Spacer()
                        //if num == 1 {
                            Image(systemName: tabBarImages[num])
                                .font(.system(size: selectedIndex == num ? 40 : 24, weight: .bold, design: .monospaced))
                                .foregroundColor(selectedIndex == num ? .red : .gray)
                        /*} else {
                            Image(systemName: tabBarImages[num])
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(selectedIndex == num ? .red : .gray)
                        }*/
                        Spacer()
                    })
                }
            }
        }
    }
}

/*struct MikesHome_Previews: PreviewProvider {
    static var previews: some View {
        MikesHome()
    }
}*/
