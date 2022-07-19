//
//  HomeViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/3/22.
//

import Foundation
import Firebase
import CoreLocation
import Combine

class HomeViewModel: ObservableObject {
    @Published var viewModelPublisher = CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>((PlaceViewModel(mapItem: nil), PlaceViewModel(mapItem: nil)))
    @Published var reservationPublisher = CurrentValueSubject<Bool, Never>(false)
    @Published var reuqestInformationPublisher = PassthroughSubject<TowRequest, Never>()
    
    func storeRequest(towRequest: TowRequest) -> Bool {
        let db = FirebaseManager.shared.firestore
        
        do {
            try db.collection("Requests").document(towRequest.id).setData(from: towRequest)
            print("Saved into requests")
            return true
        } catch {
            print("Error setting data: \(error)")
            return false
        }
    }
    
    func updateUserReservationStatus(user: User, newReservationStatus: Bool) -> Bool {
        guard let userUID = user.userUID else { return false }
        let docRef = FirebaseManager.shared.firestore.collection("Users").document(userUID)
        
        docRef.updateData([
            "hasCurrentReservation": newReservationStatus
        ])
        return true
    }
    
    func updateUserInfo(user: User) -> Bool {
        let db = FirebaseManager.shared.firestore
        guard let userUID = user.userUID else { return false }
        
        do {
            try db.collection("Users").document(userUID).setData(from: user)
            print("Saved into users")
            return true
        } catch {
            print("Error setting data: \(error)")
            return false
        }
    }
        
    func handleUserLogout(completion: (_ result: Bool) -> Void) {
        let firebaseAuth = FirebaseManager.shared.auth
        
        do {
          try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
        
    /*
    func storeUserInformation(imageProfileUrl: URL, email: String, passsword: String, completion: (_ result: Bool) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            completion(false)
            return
        }
        do {
            let user = User(id: uid, userUID: uid, userEmail: email, userMessages: [], hasCurrentReservation: false, profileImageUrl: imageProfileUrl.absoluteString, bookings: [])
    
            try FirebaseManager.shared.firestore.collection("Users").document(uid).setData(from: user)
            print("Saved into users")
            completion(true)
            return
        } catch {
            print("Error setting data: \(error)")
            completion(false)
            return
        }
    }*/
}
