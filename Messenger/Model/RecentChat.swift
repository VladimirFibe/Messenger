//
//  RecentChat.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
struct RecentChat: Codable {
  var id = ""
  var chatRoomId = ""
  var senderId = ""
  var senderName = ""
  var receiverId = ""
  var receiverName = ""
  @ServerTimestamp var date = Date()
  var memberIds = [""]
  var lastMessage = ""
  var undreadCounter = 0
  var avatar = ""
  var person: Person {
    Person(id: receiverId, avatar: avatar, status: "")
  }
  
  var timeElapsed: String {
    let seconds = Date().timeIntervalSince(date ?? Date())
    if seconds < 60 { return "Just now"}
    else if seconds < 3600 { return "\(Int(seconds / 60)) min"}
    else if seconds < 86400 { return "\(Int(seconds / 3600)) hours"}
    else { return date?.longDate() ?? ""}
  }
}

extension Date {
  func longDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    return dateFormatter.string(from: self)
  }
  
  func time() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: self)
  }
}

func startChat(person1: Person, person2: Person) -> String {
  let chatRoomId = chatRoomIdFrom(user1Id: person1.id, user2Id: person2.id)
  createRecentItems(chatRoomId: chatRoomId, persons: [person1, person2])
  return chatRoomId
}

func restartChat(chatRoomId: String, memberIds: [String]) {
  FirebaseUserListener.shared.downloadUsersFromFirebase(withIds: memberIds) { persons in
    if persons.count > 0 {
      createRecentItems(chatRoomId: chatRoomId, persons: persons)
    }
  }
}
func createRecentItems(chatRoomId: String, persons: [Person]) {
  var membersIdsToCreateRecent = persons.map{$0.id} // [persons.first!.id, persons.last!.id]
  Firestore.firestore()
    .collection("recent")
    .whereField(kCHATROOMID, isEqualTo: chatRoomId)
    .getDocuments { snapshot, error in
      guard let snapshot = snapshot else { return }
      if !snapshot.isEmpty {
        membersIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, membersIds: membersIdsToCreateRecent)
      }
      for id in membersIdsToCreateRecent {
        if let receiver = getReceiverFrom(persons: persons),
           let sender = Person.currentPerson {
          let senderPerson = id == sender.id ? sender : receiver
          let receiverPerson = id == sender.id ? receiver : sender
          let recentObject = RecentChat(id: UUID().uuidString,
                                        chatRoomId: chatRoomId,
                                        senderId: senderPerson.id,
                                        senderName: senderPerson.username,
                                        receiverId: receiverPerson.id,
                                        receiverName: receiverPerson.username,
                                        date: Date(),
                                        memberIds: [senderPerson.id, receiverPerson.id],
                                        lastMessage: "",
                                        undreadCounter: 0,
                                        avatar: receiverPerson.avatar
          )
          FirebaseRecentListener.shared.saveRecent(recentObject)
        }
      }
    }
}

func getReceiverFrom(persons: [Person]) -> Person? {
  
  var allPersons = persons
  if let person = Person.currentPerson,
     let index = allPersons.firstIndex(of: person) {
    allPersons.remove(at: index)
  }
  return allPersons.first!
}
func removeMemberWhoHasRecent(snapshot: QuerySnapshot, membersIds: [String]) -> [String] {
  var memberIdsToCreateRecent = membersIds
  for recentData in snapshot.documents {
    let currentRecent = recentData.data() as Dictionary
    if let currentPersonId = currentRecent["senderId"] as? String,
       memberIdsToCreateRecent.contains(currentPersonId),
       let index = memberIdsToCreateRecent.firstIndex(of: currentPersonId) {
      memberIdsToCreateRecent.remove(at: index)
    }
  }
  return memberIdsToCreateRecent
}

func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
  let value = user1Id.compare(user2Id).rawValue
  return value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
}
