//
//  FirebaseManager.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/7/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        //enable firestore offline caching
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        self.firestore = Firestore.firestore()
        self.firestore.settings = settings
        super.init()
    }
}
