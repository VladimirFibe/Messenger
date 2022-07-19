//
//  ChatViewController+MessagesLayoutDelegate.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesLayoutDelegate {
  // MARK: - Cell top label
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    if indexPath.section % 3 == 0 {
      if allLocalMessages.count > displayingMessagesCount { return 40 }
      else { return 18 }
    } else {
      return 0
    }
  }
  
  func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return isFromCurrentSender(message: message) ? 17 : 0
  }
  
  // MARK: - Message bottom label
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return indexPath.section != mkMessages.count - 1 ? 10 : 0
  }
  
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
  }
}


