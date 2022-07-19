//
//  MikesChatView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/9/22.
//

import SwiftUI

struct MikesChatView: View {
    @StateObject var messagesManager = MessagesManager()
    @State var towRequest: TowRequest
    @State private var showingDetailsView = false
    @ObservedObject var requestListViewModel: RequestListViewModel
    @Binding var selectedStateIndex: Int
    
    var body: some View {
        VStack {
            VStack {
                MikesTitleRow(imageUrl: towRequest.userImageUrl, numberString: "111-222-3344", requestType: towRequest.requestType, towRequest: $towRequest, requestListViewModel: requestListViewModel, selectedStateIndex: $selectedStateIndex)
                
                /*TowRequestInfoView(towRequest: self.$towRequest)
                    .frame(height: UIScreen.main.bounds.height/5)*/
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id:\.id) { message in
                            MikesMessageBubble(message: message)
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
                        .onChange(of: towRequest.requestType, perform: { reqType in
                            if reqType == "Accepted" {
                                messagesManager.sendMessage(text: "SYSTEM MESSAGE: Mike has accepted your tow request!", userID: towRequest.customerId, received: true)
                            }
                            
                            if reqType == "Rejected" {
                                messagesManager.sendMessage(text: "SYSTEM MESSAGE: Mike has rejected your tow request. Please try again later", userID: towRequest.customerId, received: true)
                            }
                            
                            if reqType == "Completed" {
                                messagesManager.sendMessage(text: "SYSTEM MESSAGE: Mike has completed your tow request!", userID: towRequest.customerId, received: true)
                            }
                        })
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(messagesManager.lastMessageId, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color.red)
        
            MessageField(userID: self.$towRequest.customerId, received: true)
                .environmentObject(messagesManager)
        }
        .onAppear {
            messagesManager.getMessages(userID: towRequest.customerId) { msgs in
                messagesManager.messages = msgs
                messagesManager.sortMessages()
            }
            /*messagesManager.retrieveUserMessages(userID: towRequest.customerId) { messagesArr in
                print(messagesArr)
                messagesManager.messages = messagesArr
                messagesManager.sortMessages()
            }*/
            print("Here are messages: \(messagesManager.messages)")
        }
    }
}
