//
//  ChatViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/28/22.
//

import Foundation
import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    var viewModelPublisher: CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>
    var messagesManager: MessagesManager
    var hasCurrentReservation: Bool
    private var cancellableSet = Set<AnyCancellable>()
    
    public init (messagesManager: MessagesManager, hasCurrentReservation: Bool, isNewBooking: Bool,
                 viewModelPublisher: CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>) {
        print("Initializer running")
        self.viewModelPublisher = viewModelPublisher
        self.messagesManager = messagesManager
        self.hasCurrentReservation = hasCurrentReservation
    }
    
    /*func subscribeToVMPublisher(isNewBooking: inout Bool, user: User) {
        if isNewBooking {
            if let sourceAddr = viewModelPublisher.value.0?.address, let destAddr = viewModelPublisher.value.1?.address, let userID = user.userUID {
                print("WE HAVE THEM")
                self.sendInitialMessage(sourceAddress: sourceAddr, destAddress: destAddr, isNewBooking: &isNewBooking, userID: userID)
            }
        }
    }
    
    func sendInitialMessage(sourceAddress: String, destAddress: String, isNewBooking: inout Bool, userID: String) {
        //if self.isNewBooking {
        print("SENDING THE MESSAGE")
        print("Source: \(sourceAddress)")
        print("Dest: \(destAddress)")
        self.messagesManager.sendMessage(text: "Hi Mike! I am looking for a tow from \(sourceAddress) to \(destAddress)", userID: userID)
        isNewBooking = false
        //}
    }*/
}
