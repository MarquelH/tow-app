//
//  MikesMessageBubble.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 6/9/22.
//

import SwiftUI

struct MikesMessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .trailing : .leading) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.received ? Color.red : Color.gray)
                    .cornerRadius(30)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 300, alignment: message.received ? .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.received ? .trailing : .leading, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .trailing : .leading)
        .padding(message.received ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}
