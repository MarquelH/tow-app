//
//  RequestListViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 5/25/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class RequestListViewModel: ObservableObject {
    var towRequests: [TowRequest]
    
    init(towRequests: [TowRequest] = [TowRequest]()) {
        self.towRequests = towRequests
    }
    
    func fetchRequests(requestType: String, completion: @escaping(_ result: [TowRequest]) -> Void) {
        let emptyList = [TowRequest]()
        let docRef = FirebaseManager.shared.firestore.collection("Requests").whereField("requestType", isEqualTo: requestType)
        self.towRequests.removeAll()
        
        docRef.getDocuments { [weak self] querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(err!)")
                return
            }
            
            for document in snapshot.documents {
                do {
                    let towRequest = try document.data(as: TowRequest.self)
                    
                    self?.towRequests.append(towRequest)
                    print("appended: \(towRequest)")
                } catch {
                    print(error)
                }
            }
            self?.towRequests.removeDuplicates()
            let source = snapshot.metadata.isFromCache ? "local cache" : "server"
            print("Metadata: Data fetched from \(source)")
            completion(self?.towRequests ?? emptyList)
        }
        
        /*let listener = docRef.addSnapshotListener(includeMetadataChanges: true) { [weak self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New request: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                }
            }
                
            for document in snapshot.documents {
                do {
                    let towRequest = try document.data(as: TowRequest.self)
                    
                    self?.towRequests.append(towRequest)
                    print("appended: \(towRequest)")
                } catch {
                    print(error)
                }
            }
            self?.towRequests.removeDuplicates()
            let source = snapshot.metadata.isFromCache ? "local cache" : "server"
            print("Metadata: Data fetched from \(source)")
            completion(self?.towRequests ?? emptyList)
        }*/
        //listener.remove()
        
    }
    
    func processSegmentedSwitch(selectedState: Int) -> [TowRequest] {
        var newRequestList = [TowRequest]()
        switch selectedState {
        case 0:
            fetchRequests(requestType: "Pending") { towRequestList in
                newRequestList = towRequestList
            }
        case 1:
            //accepted requests
            fetchRequests(requestType: "Accepted") { towRequestList in
                newRequestList = towRequestList
            }
        case 2:
            //completed requests
            fetchRequests(requestType: "Completed") { towRequestList in
                newRequestList = towRequestList
            }
        default:
            print("what is default?")
        }
        return newRequestList
    }
    
    func changeRequestType(newRequestType: String, towRequest: TowRequest, completion: @escaping(_ result: TowRequest) -> Void) {
        var docRef = FirebaseManager.shared.firestore.collection("Requests").document(towRequest.id)
                    
        //Have to update request state for user
        docRef.updateData([
            "requestType": newRequestType
        ])
        
        docRef = FirebaseManager.shared.firestore.collection("Users").document(towRequest.customerId)

        // update reservation status for the user
        if newRequestType == "Completed" {
            docRef.updateData([
                "hasCurrentReservation": false
            ])
        } else if newRequestType == "Accepted" {
            docRef.updateData([
                "hasCurrentReservation": true
            ])
        } else if newRequestType == "Rejected" {
            docRef.updateData([
                "hasCurrentReservation": false
            ])
        } else {
            
        }
        
        //Return a copy of the tow request with the updated request type
        completion(TowRequest(id: towRequest.id, customerId: towRequest.customerId, sourceName: towRequest.sourceName, destinationName: towRequest.destinationName, sourceAddress: towRequest.sourceAddress, destinationAddress: towRequest.destinationName, sourceCoordinate: towRequest.sourceCoordinate, destinationCoordinate: towRequest.destinationCoordinate, distance: towRequest.distance, requestType: newRequestType, date: towRequest.date, userImageUrl: towRequest.userImageUrl, customerFirstName: towRequest.customerFirstName, customerLastName: towRequest.customerLastName))
    }
    
    func storeUpdatedRequest(customerId: String, newTowRequest: TowRequest) -> Bool {
        let db = Firestore.firestore()
        
        //let from = GeoPoint(latitude: towRequest.sourceCoordinate.latitude, longitude: towRequest.sourceCoordinate.longitude)
        //let to = GeoPoint(latitude: towRequest.destinationCoordinate.latitude, longitude: towRequest.destinationCoordinate.longitude)
        //let fair = NSString(string: distance)
        //let floatFair = fair.floatValue * 1.2
        
        do {
            try db.collection("Requests").document(newTowRequest.id).setData(from: newTowRequest)
            print("Saved into requests")
            return true
        } catch {
            print("Error setting data: \(error)")
            return false
        }
    }
    
    func handleSegChange(tag: Int) {
        
    }
        
    func addRequest(towRequest: TowRequest) {
        
    }
    
    func organizeRequests() {
        
    }
}
