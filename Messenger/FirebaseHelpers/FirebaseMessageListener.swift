//
//  FirebaseMessageListener.swift
//  Messenger
//
//  Created by Vladimir Fibe on 18.07.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener {
  static let shared = FirebaseMessageListener()
  var newChatListener: ListenerRegistration!
//  var updateChatListener: ListenerRegistration!
  private init() {}
  
  func listenForNewChats(_ documentId: String, collectionId: String, lastMessageDate: Date) {
    newChatListener = Firestore.firestore()
      .collection("message")
      .document(documentId)
      .collection(collectionId)
      .whereField("date", isGreaterThan: lastMessageDate)
      .addSnapshotListener({ querySnapshot, error in
      guard let snapshot = querySnapshot else { return }
      for change in snapshot.documentChanges {
        if change.type == .added {
          let result = Result {
            try? change.document.data(as: LocalMessage.self)
          }
          
          switch result {
          case .success(let messageObject):
            if let message = messageObject {
              RealmManager.shared.saveToRealm(message)
            } else {
              print("Document doesnt exist")
            }
          case .failure(let error):
            print("Error decoding local message: \(error.localizedDescription)")
          }
        }
      }
    })
  }
  
  func checkForOldChats(_ documentId: String, collectionId: String) {
    Firestore.firestore()
      .collection("message")
      .document(documentId)
      .collection(collectionId)
      .getDocuments { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
          print("no documents for old chats")
          return
        }
        var oldMessages = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: LocalMessage.self)
        }
        oldMessages.sort(by: { $0.date < $1.date })
        for message in oldMessages {
          RealmManager.shared.saveToRealm(message)
        }
      }
  }
  // MARK: - Add, Update, Delete
  
  func addMessage(_ message: LocalMessage, memberId: String) {
    do {
      let _ = try Firestore.firestore().collection("message").document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
      
    } catch {
      print("error saving message \(error.localizedDescription)")
    }
  }
  // MARK: - Update Message Status
  func updateMessageInFirebase(_ message: LocalMessage, memberIds: [String]) {

    let values = ["status": "read", "readDate": Date()] as [String: Any]
    for memberId in memberIds {
      print("DEBUG: ", memberId)
      Firestore.firestore()
        .collection("message")
        .document(memberId)
        .collection(message.chatRoomId)
        .document(message.id)
        .updateData(values)
    }
  }
  
  func removeListener() {
    self.newChatListener.remove()
//    self.updateChatListener.remove()
  }
}
