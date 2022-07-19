//
//  MenuView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/7/22.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Search")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 75)
            }
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Profile")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 20)
            }
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "message.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Inbox")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 20)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
