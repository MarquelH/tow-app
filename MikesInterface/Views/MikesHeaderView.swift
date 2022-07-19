//
//  MikesHeaderView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/13/22.
//

import SwiftUI

struct MikesHeaderView: View {
    @Binding var loggedInStatus: Int
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Tow Requests")
                    .fontWeight(.bold)
                    .font(.title)
            }
            
            Spacer()
            
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
