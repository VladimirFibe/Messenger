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
  func addRecent(_ recent: RecentChat) {
    do {
      try Firestore.firestore().collection("recent").document(recent.id).setData(from: recent)
    } catch {
      print("Error saving recent chat \(error.localizedDescription)")
    }
    
  }
}

