//
//  ContentView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 2/24/22.
//

import SwiftUI

struct ContentView: View {
    let homeViewModel = HomeViewModel()
    @State var loggedInStatus = 0
    @State var user = User()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                switch loggedInStatus {
                case 0:
                    LoginView(isLoggedIn: $loggedInStatus, user: $user)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                case 1:
                    Home(homeViewModel: homeViewModel, user: $user, loggedInStatus: $loggedInStatus)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                case 2:
                    MikesHome(user: $user, loggedInStatus: $loggedInStatus)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                default:
                    LoginView(isLoggedIn: $loggedInStatus, user: $user)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Views Are Kept In Separate File....
