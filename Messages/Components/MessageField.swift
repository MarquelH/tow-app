//
//  MessageField.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/11/22.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messagesManager: MessagesManager
    @Binding var userID: String
    @State private var message = ""
    var received: Bool
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            
            Button {
                messagesManager.sendMessage(text: message, userID: userID, received: received)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray)
        .cornerRadius(50)
        .padding()
    }
}

/*struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField()
    }
}*/

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
                    .foregroundColor(.white)
            }
            
            TextField("", text: $text,
                      onEditingChanged:editingChanged,
                      onCommit: commit)
                .foregroundColor(.white)
        }
    }
}
