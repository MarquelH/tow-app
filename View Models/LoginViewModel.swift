//
//  LoginViewModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 4/11/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class LoginViewModel: ObservableObject {
    private let defaultImageUrlString = "https://firebasestorage.googleapis.com:443/v0/b/middleton-75caf.appspot.com/o/7wIdpf5xmDM4VH1canr71x7Uh492?alt=media&token=b388a2d4-f70e-4a94-8476-4d6373007182"
    
    func createNewAccountAndStoreData(image: UIImage?, email: String, password: String, phoneNumber: String, firstName: String, lastName: String, completion: @escaping (_ result: User) -> Void) {
        var loginStatusMessage = ""
        var userDetails = [String:String]()
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
             firebaseResult, err in
             if let err = err {
                 loginStatusMessage = "Failed to create user: \(err)"
                 print(loginStatusMessage)
                return
             }
            loginStatusMessage = "Successfully created user: \(firebaseResult?.user.uid ?? "")"
            print(loginStatusMessage)
                var accountStorageIndicator = (false, "")
                self.persistImageToStorage(image: image, email: email, password: password, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName) { storageResult in
                    accountStorageIndicator = storageResult
                if accountStorageIndicator.0 {
                    print("STORAGE INDICATOR RETURNED TRUE")
                    userDetails["userUID"] = firebaseResult?.user.uid ?? ""
                    userDetails["userEmail"] = email
                    userDetails["profileImageUrl"] = accountStorageIndicator.1
                }
                if let userID = userDetails["userUID"], let profileImageUrl = userDetails["profileImageUrl"] {
                    print("HERE ARE USER DETAILS")
                    let usr = User(id: userID, userUID: userID, userEmail: email, userMessages: [], hasCurrentReservation: false, profileImageUrl: profileImageUrl, bookings: [], phoneNumber: phoneNumber, firstName: firstName, lastName: lastName)
                    completion(usr)
                } else {
                    print("HERE THERE ARE NOT THE DETAILS : \(userDetails)")
                    completion(User())
                }
                }
            }
    }
    
    func persistImageToStorage(image: UIImage?, email: String, password: String, phoneNumber: String, firstName: String, lastName: String, completion: @escaping (_ result: (Bool,String)) -> Void) {
        var urlResult = ""
        var boolResult = false
        
        if image == nil {
            //Storing default image to db
            if let defaultImageUrl = URL(string: defaultImageUrlString) {
                self.storeUserInformation(imageProfileUrl: defaultImageUrl, email: email, passsword: password, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName) { result in
                    urlResult = defaultImageUrl.absoluteString
                    print("Successfully stored image with url: \(urlResult)")
                    boolResult = result
                    completion((boolResult, urlResult))
                }
            } else {
                print("Not a valid URL somwehow???")
            }
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("NO USER ID")
            completion((false, ""))
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            print("NO IMAGE DATA")
            completion((false, ""))
            return
        }
                
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            ref.downloadURL{ url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                }
                guard let url = url else {
                    print("NO URL")
                    return
                    
                }
                // Storing user given image to db
                self.storeUserInformation(imageProfileUrl: url, email: email, passsword: password, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName) { result in
                    urlResult = url.absoluteString
                    print("Successfully stored image with url: \(urlResult)")
                    boolResult = result
                    completion((boolResult, urlResult))
                }
            }
        }
        //print("returning :\(boolResult)")
        //print(urlResult)
        //completion((boolResult, urlResult))
    }
    
    func storeUserInformation(imageProfileUrl: URL, email: String, passsword: String, phoneNumber: String, firstName: String, lastName: String, completion: (_ result: Bool) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            completion(false)
            return
        }
        do {
            let user = User(id: uid, userUID: uid, userEmail: email, userMessages: [], hasCurrentReservation: false, profileImageUrl: imageProfileUrl.absoluteString, bookings: [], phoneNumber: phoneNumber, firstName: firstName, lastName: lastName)
    
            try FirebaseManager.shared.firestore.collection("Users").document(uid).setData(from: user)
            print("Saved into users")
            completion(true)
            return
        } catch {
            print("Error setting data: \(error)")
            completion(false)
            return
        }
    }
    
    func loginUserAndGetData(email: String, password: String, completion: @escaping(_ result: User) -> Void) {
        let loggedInUser = User()
        
        loginUser(email: email, password: password) { resultUser in
            guard let userId = resultUser.userUID else {
                print("no userId?")
                completion(loggedInUser)
                return
            }
            
            let docRef = FirebaseManager.shared.firestore.collection("Users").document(userId)
            
            docRef.getDocument(as: User.self) { result in
                switch result {
                    case .success(let user):
                        print("FOUND USER!")
                        completion(user)
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (_ result: User) -> Void) {
        var loginStatusMessage = ""
        DispatchQueue.main.async {
            
            //Sign in via Firebase
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
                result, err in
                if let err = err {
                    loginStatusMessage = "Failed to login user: \(err))"
                    print(loginStatusMessage)
                    return
                }
                if let userUID = result?.user.uid {
                    loginStatusMessage = "Successfully logged in as user: \(userUID)"
                    let usr = User(id: userUID, userUID: userUID, userEmail: email)
                    completion(usr)
                } else {
                    print("No userUID???")
                }
                print(loginStatusMessage)
            }
        }
    }
}


