//
//  MikesTitleRow.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/10/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MikesTitleRow: View {
    var imageUrl: URL
    var numberString: String
    @State var shouldShowDetails = false
    @State var requestType: String
    @State var alert = false
    @Binding var towRequest: TowRequest
    @ObservedObject var requestListViewModel: RequestListViewModel
    @Binding var selectedStateIndex: Int
    var didActionHappen = false
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .center) {
                    Text("\(towRequest.customerFirstName) \(towRequest.customerLastName.first!.description)")
                        .font(.title).bold()
                        .foregroundColor(Color.white)
                    
                    Text("Tow on \(towRequest.date.month) \(towRequest.date.get(.day))")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                    
                    Text(towRequest.requestType)
                        .font(.subheadline)
                        .foregroundColor(towRequest.requestType == "Accepted" ? Color.green : Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
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
            
            HStack(spacing: 5) {
                if requestType == "Pending" {
                    Button {
                        requestListViewModel.changeRequestType(newRequestType: "Accepted", towRequest: towRequest) { towRequest in
                            self.towRequest = towRequest
                            self.requestType = towRequest.requestType
                            self.selectedStateIndex = 1
                        }
                    } label: {
                        Text("Accept")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .center)
                    }
                    .background(Color.green)
                    .clipShape(Capsule())
                    
                    Button {
                        requestListViewModel.changeRequestType(newRequestType: "Rejected", towRequest: towRequest) { towRequest in
                            self.towRequest = towRequest
                            self.requestType = towRequest.requestType
                            self.selectedStateIndex = 2
                        }
                    } label: {
                        Text("Reject")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .center)
                    }
                    .background(Color.green)
                    .clipShape(Capsule())
                    
                    Button {
                        self.shouldShowDetails = true
                    } label: {
                        Text("View Details")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .center)
                    }
                    .background(Color.gray)
                    .clipShape(Capsule())
                    
                } else if requestType == "Accepted" {
                    Button {
                        requestListViewModel.changeRequestType(newRequestType: "Completed", towRequest: towRequest) { towRequest in
                            self.towRequest = towRequest
                            self.requestType = towRequest.requestType
                            self.selectedStateIndex = 2
                        }
                    } label: {
                        Text("Complete")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    }
                    
                    Button {
                        self.shouldShowDetails = true
                    } label: {
                        Text("View Details")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    }
                    .background(Color.gray)
                    .clipShape(Capsule())
                } else {
                    Button {
                        self.shouldShowDetails = true
                    } label: {
                        Text("View Details")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 2, alignment: .center)
                    }
                    .frame(alignment: .center)
                    .background(Color.gray)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $shouldShowDetails) {
            RequestDetailsView(alert: self.$alert, source: $towRequest.sourceCoordinate, destination: $towRequest.destinationCoordinate, destinationName: $towRequest.destinationName, sourceName: $towRequest.sourceName, distance: $towRequest.distance, shouldShowDetails: self.$shouldShowDetails, date: towRequest.date, towRequest: towRequest)
        }

    }
}
