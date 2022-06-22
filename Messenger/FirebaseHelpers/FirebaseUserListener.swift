//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by Vladimir Fibe on 22.06.2022.
//

import Foundation
import Firebase

class FirebaseUserListener {
  static let shared = FirebaseUserListener()
  private init() {}
  
  // MARK: - Login
  
  
  // MARK: - Register
  func registerUser(withEmail email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      completion(error)
    }
  }
}
