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
}
