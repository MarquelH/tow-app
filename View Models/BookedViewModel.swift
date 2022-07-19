//
//  BookedViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/2/22.
//

import Foundation
import SwiftUI

class BookedViewModel: ObservableObject {
    
    func returnImageView(data: Data) -> Image {
        guard let imageData = UIImage(data: data) else {
            print("No Image for data")
            return Image(systemName: "questionmark")
        }
        return Image(uiImage: imageData)
    }
}
