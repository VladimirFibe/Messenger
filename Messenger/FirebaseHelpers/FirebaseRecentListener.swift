//
//  FirebaseRecentListener.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseRecentListener {
  static let shared = FirebaseRecentListener()
  private init () {}
  
  func downloadRecentCthatsFromFireStore(completion: @escaping ([RecentChat]) -> Void) {
    
    Firestore.firestore()
      .collection("recent")
      .whereField("senderId", isEqualTo: Person.currentId)
      .addSnapshotListener { quarySnapshot, error in
        var recentChats: [RecentChat] = []
        guard let documents = quarySnapshot?.documents else {
          print("no documents for rececent chats")
          completion([])
          return
        }
        let allRecents = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
          try? queryDocumentSnapshot.data(as: RecentChat.self)
        }
        for recent in allRecents {
          if recent.lastMessage != "" {
            recentChats.append(recent)
          }
        }
        recentChats.sort(by: { $0.date! > $1.date!})
        completion(recentChats)
      }
  }
  
  func saveRecent(_ recent: RecentChat) {
    do {
      try Firestore.firestore().collection("recent").document(recent.id).setData(from: recent)
    } catch {
      print("Error saving recent chat \(error.localizedDescription)")
    }
    
  }
  
  func updateRecents(chatRoomId: String, lastMessage: String) {
    Firestore.firestore().collection("recent").whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents else { return }
      let allRecents: [RecentChat] = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: RecentChat.self)
      }
      for recent in allRecents {
        self.updateRecentItemWithNewMessage(recent: recent, lastMessage: lastMessage)
      }
    }
  }
  func resetRecentCounter(chatRoomId: String) {
    Firestore.firestore().collection("recent").whereField("chatRoomId", isEqualTo: chatRoomId).whereField("senderId", isEqualTo: Person.currentId).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents else {
        print("no documents for recent")
        return
      }
      let allRecents = documents.compactMap {  try? $0.data(as: RecentChat.self) }
      if allRecents.count > 0 { self.clearUnreadCounter(recent: allRecents.first!)}
    }
  }
  
  private func updateRecentItemWithNewMessage(recent: RecentChat, lastMessage: String) {
    var tempRecent = recent
    if tempRecent.senderId != Person.currentId {
      tempRecent.undreadCounter += 1
    }
    tempRecent.lastMessage = lastMessage
    tempRecent.date = Date()
    self.saveRecent(tempRecent)
  }
  
  func clearUnreadCounter(recent: RecentChat) {
    Firestore.firestore().collection("recent").document(recent.id).updateData(["undreadCounter": 0])
  }
  
  func deleteRecent(_ recent: RecentChat) {
    Firestore.firestore().collection("recent").document(recent.id).delete()
  }
}

