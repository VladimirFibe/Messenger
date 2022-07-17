//
//  Person.swift
//  Messenger
//
//  Created by Vladimir Fibe on 21.06.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Person: Codable, Equatable {
  var id = ""
  var username = ""
  var email = ""
  var pushId = ""
  var avatar = ""
  var status: String
  
  static var currentId: String {
    Auth.auth().currentUser?.uid ?? ""
  }
  
  static var currentPerson: Person? {
    if Auth.auth().currentUser != nil {
      if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
        let decoder = JSONDecoder()
        do {
          let object = try decoder.decode(Person.self, from: dictionary)
          return object
        } catch {
          print("Error decoding user from user defaults \(error.localizedDescription)")
        }
      }
    }
    return nil
  }
  
  static func ==(lhs: Person, rhs: Person) -> Bool {
    lhs.id == rhs.id
  }
  
  static func save(_ person: Person) {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(person)
      UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
      print("error saving user localy \(error.localizedDescription)")
    }
  }
}

func createDummyUsers() {
  let names = ["Alison Stamp", "Inayah Duggan", "Alfie Thornton", "Rachelle Neale", "Anya Gates", "Juanita Bate"]
  for i in 0..<5 {
    
    let id = UUID().uuidString
    let fileDirectory = "avatars/\(id).jpg"
    FileStorage.uploadImage(UIImage(named: "user\(i+1)")!, directory: fileDirectory) { (avatarLink) in
      
      let person = Person(id: id,
                          username: names[i],
                          email: "user\(i+1)@mail.com",
                          pushId: "",
                          avatar: avatarLink ?? "",
                          status: Status.allCases.randomElement()?.rawValue ?? "no status")
      
      FirebaseUserListener.shared.savePersonToFireStore(person)
    }
  }
}
