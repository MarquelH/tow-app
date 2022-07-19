//
//  HeaderView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/8/22.
//

import SwiftUI

struct HeaderView: View {
    @Binding var search: Bool
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var loggedInStatus: Int
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Mike's Towing")
                    .fontWeight(.bold)
                    .font(.title)
            }
            
            Spacer()
            
            Button(action: {
                
                self.search.toggle()
                
            }) {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
            }
            
            Button {
                homeViewModel.handleUserLogout { result in
                    if result {
                        withAnimation {
                            self.loggedInStatus = 0
                        }
                    }
                }
            } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
            }
        }
    }
}
