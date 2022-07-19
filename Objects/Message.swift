//
//  MessageModel.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/11/22.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    var id: String
    var received: Bool
    var text: String
    var timestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        self.id = ""
        self.received = false
        self.text = ""
        self.timestamp = Date.init()
    }
    
    init(id: String, received: Bool, text: String, timestamp: Date) {
        self.id = id
        self.received = received
        self.text = text
        self.timestamp = timestamp
    }
}
