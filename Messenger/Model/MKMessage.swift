//
//  MKMessage.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import MessageKit
import CoreLocation

  
class MKMessage: NSObject, MessageType {
  var messageId: String
  var kind: MessageKit.MessageKind
  var sentDate: Date
  var incoming: Bool
  var mkSender: MKSender
  var sender: MessageKit.SenderType { mkSender }
  var senderInitials: String
  var status: String
  var readDate: Date
  
  init(message: LocalMessage) {
    self.messageId = message.id
    self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
    self.status = message.status
    self.kind = MessageKind.text(message.message)
    self.sentDate = message.date
    self.incoming = Person.currentId != mkSender.senderId
    self.senderInitials = message.senderInitials
    self.readDate = message.readDate
  }
}
