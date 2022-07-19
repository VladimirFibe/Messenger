//
//  OutgoingMessage.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class OutgoingMessage {
  class func send(chatId: String,
                  text: String?,
                  photo: UIImage?,
                  video: String?,
                  audio: String?,
                  location: String?,
                  audioDuration: Float = 0.0,
                  memberIds: [String]) {
    guard let currentPerson = Person.currentPerson else { return }
    let message = LocalMessage()
    message.id = UUID().uuidString
    message.chatRoomId = chatId
    message.senderId = currentPerson.id
    message.senderInitials = String(currentPerson.username.first!)
    message.date = Date()
    message.status = "Sent"
    if let text = text {
      sendTextMessage(message: message, text: text, membersIds: memberIds)
    }
    
    //TODO: Send push notification
    //TODO: Update recent
    FirebaseRecentListener.shared.updateRecents(chatRoomId: chatId, lastMessage: message.message)
  }
  
  class func sendMessage(message: LocalMessage, memberIds: [String]) {
    RealmManager.shared.saveToRealm(message)
    for memberId in memberIds {
      FirebaseMessageListener.shared.addMessage(message, memberId: memberId)
    }
  }
}

func sendTextMessage(message: LocalMessage, text: String, membersIds: [String]) {
  message.message = text
  message.type = "text"
  OutgoingMessage.sendMessage(message: message, memberIds: membersIds)
}
