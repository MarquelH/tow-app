//
//  TowRequest.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/3/22.
//

import Foundation
import CoreLocation

struct TowRequest: Codable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(customerId)
    }
    
    static func == (lhs: TowRequest, rhs: TowRequest) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    var id: String
    var customerId: String
    var sourceName: String
    var destinationName: String
    var sourceAddress: String
    var destinationAddress: String
    var sourceCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var distance: String
    var requestType: String
    var date: Date
    var userImageUrl: URL
    var customerFirstName: String
    var customerLastName: String
    
    /*init(id: String,
         customerId: String,
         userName: String,
         sourceName: String,
         destinationName: String,
         sourceAddress: String,
         destinationAddress: String,
         distance: String,
         isAccepted: Bool,
         date: Date) {
        self.id = id
        self.customerId = id
        self.userName = userName
        self.sourceName = sourceName
        self.destinationName = destinationName
    }*/
}
