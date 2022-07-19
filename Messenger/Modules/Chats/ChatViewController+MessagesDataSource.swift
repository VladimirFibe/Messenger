//
//  ChatViewController+MessagesDataSource.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDataSource {
  func currentSender() -> MessageKit.SenderType {
    currentUser
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
    mkMessages[indexPath.section]
  }
  
  func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
    mkMessages.count
  }
  // MARK: - Cell top Labels
  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if indexPath.section % 3 == 0 {
      let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)
      let text = showLoadMore ? "Pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
      let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
      let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
      return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    return nil
  }
  
  // Cell bottom label
  func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if isFromCurrentSender(message: message) {
      let message = mkMessages[indexPath.section]
      let status = indexPath.section == mkMessages.count - 1 ? "\(message.status) \(message.readDate.time())" : ""
      return NSAttributedString(string: status, attributes: [.font: UIFont.boldSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
    } else {
      return nil
    }
  }
  
  // Message bottom label
  func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    
    if indexPath.section != mkMessages.count - 1 {
      return NSAttributedString(string: message.sentDate.time(), attributes: [.font: UIFont.boldSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
    } else {
      return nil
    }
  }
}


