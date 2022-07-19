//
//  MessagesManager.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/15/22.
//

import Foundation
import Combine
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesManager: ObservableObject {
    @Published var messages: [Message] = []
    @Published private(set) var lastMessageId = ""

    let db = Firestore.firestore()
    
    /*init(userId: String? = nil) {
        print("INITIALIZING MESSAGESMANAGER")
        print(userId)
        if let userId = userId {
            getMessages(userID: userId)
        } else {
            print("NO USERID")
        }
    }*/
    
        func sortMessages() {
        // db.collection("Users").document(user.id).collection("messages")
        //db.collection("Users").document(userId).collection("userMessages").addSnapshotListener { querySnapshot, error in
            /*guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }*/
        /*guard let data = querySnapshot?.data() else {
                print("no good")
                return
            }*/
            //let thisData = data["userMessages"]
            self.messages.sort { $0.timestamp < $1.timestamp }
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
    }
    
    func deleteAllMessages() {
        
    }
    
    func getMessages(userID: String, completion: @escaping(_ result: [Message]) -> Void) {
        var msgs = [Message()]
        print("GETTING MESSAGES")
        let docRef = FirebaseManager.shared.firestore.collection("Users").document(userID)
        
        /*docRef.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, err in
            if let err = err {
                    print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("DOCUMENT: \(document)")
                    do {
                        let message = try document.data(as: Message.self)
                        print("APPENDING MESSAGE: \(message)")
                        msgs.append(message)
                        
                    } catch {
                        print("HERES THE ERROR: \(error)")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completion(msgs)
            }
        }*/
        
        /*docRef.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error is \(error)")
                return
            }
            self.messages = documents.compactMap{ document -> Message? in
                do {
                    print("DOCUMENT: \(document)")
                    return try document.data(as: Message.self)
                } catch {
                    print("Error: \(error)")
                    return nil
                }
            }
        }*/
        self.sortMessages()
        
        /*let listener = docRef.addSnapshotListener(includeMetadataChanges: true) {querySnapshot, error in
            
            
        }*/
        
        docRef.getDocument(as: User.self) { result in
            switch result {
                case .success(let user):
                    print("FOUND USER!")
                    self.messages = user.userMessages ?? []
                    self.sortMessages()
                    completion(self.messages)
                case .failure(let error):
                    print("Error decoding user: \(error)")
            }
        }
        //self.messages.removeAll()
        
        /*docRef.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, err in
            if let err = err {
                    print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("DOCUMENT: \(document)")
                    do {
                        let message = try document.data(as: Message.self)
                        print("APPENDING MESSAGE: \(message)")
                        msgs.append(message)
                        
                    } catch {
                        print("HERES THE ERROR: \(error)")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completion(msgs)
            }
        }*/
    }
    
    func sendMessage(text: String, userID: String, isInitial: Bool = false, received: Bool) -> Message {
        print("Sending a message!")
        let newMessage = Message(id: "\(UUID())", received: received, text: text, timestamp: Date())
        let newMessageForDB = [newMessage]
        
        if userID == "" {
            return Message()
        }
        
        let docRef = FirebaseManager.shared.firestore.collection("Users").document(userID)
            
        docRef.updateData([
            "userMessages": FieldValue.arrayUnion(newMessageForDB.compactMap({ try? Firestore.Encoder().encode($0)}) )
        ])
        
        if !isInitial {
            self.messages.append(newMessage)
        }
        self.sortMessages()
        print("NEW MESSAGE HERE: \(newMessage)")
        return newMessage
    }
    
    
    func sendInitialMessage(text: String) {
        print("Sending a message!")
        do {
            let newMessage = Message(id: "\(UUID())", received: false, text: text, timestamp: Date())
    
            try db.collection("Messages").document().setData(from: newMessage)
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
}
