//
//  MessageKitDefaults.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import UIKit
import MessageKit

struct MKSender: SenderType, Equatable {
  var senderId: String
  
  var displayName: String
  
}

enum MessageDefailts {
  static let bubbleColorOutgoing = #colorLiteral(red: 0.8820000291, green: 0.9670000076, blue: 0.7919999957, alpha: 1)
  static let bubbleColorIncoming = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
}
