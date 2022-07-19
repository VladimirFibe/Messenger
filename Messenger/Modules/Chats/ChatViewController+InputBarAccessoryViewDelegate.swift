//
//  ChatViewController+InputBarAccessoryViewDelegate.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import MessageKit
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
    if text != "" {
      typingCounerUpdate()
    }
    updateMicButtonStatus(show: text == "")
  }
  
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    for component in inputBar.inputTextView.components {
      if let text = component as? String {
        messageSend(text: text)
      }
    }
    
    messageInputBar.inputTextView.text = ""
    messageInputBar.invalidatePlugins()
  }
}
