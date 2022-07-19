//
//  SearchAutocompleteView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/22/22.
//

import SwiftUI
import Combine
import CoreLocation

struct SearchAutocompleteView: View {
    @Binding var presentedAsModal: Bool
    @Binding var sourceSelection: String
    @Binding var destSelection: String
    @Binding var isSourceSelection: Bool
    @Binding var sourceLocation: CLLocationCoordinate2D?
    @Binding var destinationLocation: CLLocationCoordinate2D?
    @State var isSelected = false
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
    @Binding var sourceViewModel: PlaceViewModel
    @Binding var destViewModel: PlaceViewModel
        
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: true) {
                    ForEach(vm.places, id: \.self) { place in
                        PlaceItemView(placeViewModel: place)
                            .onTapGesture {
                                if self.isSourceSelection {
                                    self.sourceSelection = place.name
                                    self.sourceLocation = place.coordinate
                                    self.sourceViewModel = place
                                } else {
                                    self.destSelection = place.name
                                    self.destinationLocation = place.coordinate
                                    self.destViewModel = place
                                }
                                self.presentedAsModal = false
                            }
                    }.searchable(text: $vm.searchText)
                }
                if vm.isResponseEmpty {
                    Text("No Results :(")
                }
                /*List(vm.places, selection: self.isSourceSelection ? $sourceSelection : $destSelection) { place in
                    Text(place.name)
                        .font(.headline)
                    Text(place.address)
                        .font(.footnote)
                }*/
                Button(action: {
                    self.presentedAsModal = false
                }) {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .background(Color.red)
                .clipShape(Capsule())
            }
            .navigationTitle("Location Search")
        }
    }
}
