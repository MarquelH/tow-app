//
//  ChatView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/11/22.
//

import SwiftUI
import Combine
import CoreLocation

struct ChatView: View {
    @Binding var hasRequest: Bool
    @Binding var isNewBooking: Bool
    @Binding var hasCurrentReservation: Bool
    @Binding var user: User
    //@State var user: User
    @StateObject var messagesManager = MessagesManager()
    @Binding var selectedIndex: Int
    var viewModelPublisher: CurrentValueSubject<(PlaceViewModel?, PlaceViewModel?), Never>
    //var chatViewModel: ChatViewModel
    //@Binding var sourceViewModel: PlaceViewModel
    //@Binding var destinationViewModel: PlaceViewModel
    /*var name: String
    var source: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    var distance: String*/
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(imageUrl: URL(string: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8")!, numberString: "845-538-7893")
                
                ScrollViewReader { proxy in
                    ScrollView {
                        if self.hasRequest {
                            if messagesManager.messages.isEmpty {
                                //THIS SHOULDN'T EVEN HAPPEN LOL
                                Text("No messages yet! Send a message to start a conversation")
                                    .font(.headline)
                                    .padding()
                                    .frame(alignment: .center)
                            } else {
                                ForEach(messagesManager.messages, id:\.id) { message in
                                    MessageBubble(message: message)
                                }
                            }
                        } else {
                            Text("This is where you chat with Mike once you request a tow!")
                                .font(.headline)
                                .padding()
                                .frame(alignment: .center)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of:
                        messagesManager.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo(messagesManager.lastMessageId, anchor: .bottom)
                            }
                        }
                }
            }
            .background(Color.red)
        
            MessageField(userID: self.$user.id, received: false)
                .environmentObject(messagesManager)
        }
        .onAppear {
            messagesManager.getMessages(userID: user.id) { msgs in
                messagesManager.messages = msgs
                messagesManager.sortMessages()
            }
            //This should be in chatViewModel
            if let userID = self.user.userUID, let userMessages = self.user.userMessages {
                print("MESSAGES: \(userMessages)")
                self.messagesManager.messages = userMessages
                //Check for new request to send first auto-message
                if self.isNewBooking && self.hasCurrentReservation {
                    if let sourceAddr = self.viewModelPublisher.value.0?.name, let destAddr = self.viewModelPublisher.value.1?.name {
                        print("WE HAVE BOTH \(sourceAddr) & \(destAddr)")
                        messagesManager.messages.append(
                            messagesManager.sendMessage(text: "Hi Mike! I am looking for a tow from \(sourceAddr) to \(destAddr)", userID: userID, isInitial: true, received: false)
                        )
                        messagesManager.sortMessages()
                        self.isNewBooking = false
                    }
                }
            } else {
                print("NO USER FOR THIS CHAT VIEW")
            }
            
            /*if let userUID = user.userUID {
                //check if user was updated
                let docRef = FirebaseManager.shared.firestore.collection("Users").whereField("id", isEqualTo: userUID)
                
                docRef.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        if (diff.type == .added) {
                            print("New user: \(diff.document.data())")
                        }
                        if (diff.type == .modified) {
                            print("Modified user: \(diff.document.data())")
                        }
                        if (diff.type == .removed) {
                            print("Removed user: \(diff.document.data())")
                        }
                    }
                    
                    let source = snapshot.metadata.isFromCache ? "local cache" : "server"
                    print("Metadata: Data fetched from \(source)")
                }*/
                /*
                docRef.getDocument(as: User.self) { result in
                    switch result {
                        case .success(let user):
                            print("FOUND USER!")
                        self.user = user
                        case .failure(let error):
                            print("Error decoding user: \(error)")
                    }
                }*/
            }
            
            //if let userHasRequest = user.hasCurrentReservation {
                //hasRequest = userHasRequest
            //}
        }
}
