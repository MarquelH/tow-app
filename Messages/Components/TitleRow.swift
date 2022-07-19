//
//  TitleRow.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/11/22.
//

import SwiftUI

struct TitleRow: View {
    var imageUrl: URL
    var name = "Mike"
    var numberString: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(uiImage: UIImage(named: "MIKESIMAGE")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            
            /*AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }*/
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title).bold()
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                let telephone = "tel://"
                let formattedString = telephone + numberString
                guard let url = URL(string: formattedString) else { return }
                UIApplication.shared.open(url)
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
            }
        }
        .padding()
    }
}
