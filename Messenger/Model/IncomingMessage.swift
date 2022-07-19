//
//  IncomingMessage.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
  var messageCollectionView: MessagesViewController
  init(_collectionView: MessagesViewController) {
    messageCollectionView = _collectionView
  }
  // MARK: - Create Message
  func createMessage(localMessage: LocalMessage) -> MKMessage? {
    let mkMessage = MKMessage(message: localMessage)
    return mkMessage
  }
}
