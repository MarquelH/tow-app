//
//  PlaceItemView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/23/22.
//

import SwiftUI

struct PlaceItemView: View {
    @State var placeViewModel: PlaceViewModel
    var body: some View {
        VStack {
            Text(placeViewModel.name)
                .font(.headline)
            Text(placeViewModel.address)
                .font(.footnote)
            Divider()
        }
    }
}
