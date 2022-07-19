//
//  TowRequestInfoView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/9/22.
//

import SwiftUI

struct TowRequestInfoView: View {
    @Binding var towRequest: TowRequest
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("From")
                        .font(.headline)
                    Text("\(towRequest.sourceName)")
                        .font(.subheadline)
                }.layoutPriority(1)
                
                VStack {
                    Text("To")
                        .font(.headline)
                    Text("\(towRequest.destinationName)")
                        .font(.subheadline)
                }.layoutPriority(2)
            }
            
            HStack(spacing: 5) {
                Button {
                    print("Accept")
                } label: {
                    Text("Accept Request")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .padding(.leading)
                }
                .background(Color.green)
                .clipShape(Capsule())
                
                
                Button {
                    print("View Details")
                } label: {
                    Text("View Details")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .padding(.trailing)
                }
                .background(Color.black)
                .clipShape(Capsule())
            }
        }
        .background(Color.white)
    }
}
