//
//  User.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/29/22.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var userUID: String?
    var userEmail: String?
    var userMessages: [Message]?
    var hasCurrentReservation: Bool?
    var profileImageUrl: String?
    var bookings: [TowRequest]?
    var phoneNumber: String?
    var firstName: String?
    var lastName: String?
    
    init(id: String = "\(UUID())", userUID: String, userEmail: String, userMessages: [Message]? = nil, hasCurrentReservation: Bool? = nil, profileImageUrl: String? = nil, bookings: [TowRequest]? = nil, phoneNumber: String? = nil, firstName: String? = nil,
         lastName: String? = nil) {
        self.id = id
        self.userUID = userUID
        self.userEmail = userEmail
        self.userMessages = userMessages
        self.hasCurrentReservation = hasCurrentReservation
        self.profileImageUrl = profileImageUrl
        self.bookings = bookings
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init() {
        print("FROM EMPTY")
        self.id = "\(UUID())"
        self.userUID = nil
        self.userEmail = nil
        self.userMessages = nil
        self.hasCurrentReservation = nil
        self.profileImageUrl = nil
        self.bookings = nil
        self.phoneNumber = nil
        self.firstName = nil
        self.lastName = nil
    }
}
