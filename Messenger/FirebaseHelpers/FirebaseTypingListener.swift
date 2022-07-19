//
//  FirebaseTypingListener.swift
//  Messenger
//
//  Created by Vladimir Fibe on 19.07.2022.
//

import Foundation
import Firebase

class FirebaseTypingListener {
  static let shared = FirebaseTypingListener()
  var typingListener: ListenerRegistration!
  private init() {}
  func createTypingOnserver(chatRoomId: String, completion: @escaping (Bool) -> Void) {
    typingListener = Firestore.firestore()
      .collection("typing")
      .document(chatRoomId)
      .addSnapshotListener({ snapshot, error in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
          for data in snapshot.data()! {
            if data.key != Person.currentId {
              completion(data.value as! Bool)
            }
          }
        } else {
          completion(false)
          Firestore.firestore().collection("typing").document(chatRoomId).setData([Person.currentId: false])
        }
    })
  }
  
  class func saveTypingCounter(typing: Bool, chatRoomId: String) {
    Firestore.firestore().collection("typing").document(chatRoomId).updateData([Person.currentId: typing])
  }
  
  func removeTypingListener() {
    self.typingListener.remove()
  }
}
