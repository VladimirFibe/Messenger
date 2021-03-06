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
  
  func loginUser(withEmail email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if error == nil && result!.user.isEmailVerified {
        self.downloadUserFromFirebase(userId: result!.user.uid, email: email)
        completion(error, true)
      } else {
        print("email is not verified")
        completion(error, false)
      }
    }
  }
  // MARK: - Register
  func registerUser(withEmail email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      completion(error)
      if error == nil {
        // send verificaton email
        result?.user.sendEmailVerification { error in
          print("auth email sent with error: \(error?.localizedDescription ?? "nil")")
        }
        
        // create user and save it
        
        if let user = result?.user {
          let person = Person(id: user.uid, username: email, email: email, status: "Hey there, I'm using Messager")
          Person.save(person)
          self.savePersonToFireStore(person)
        }
      }
    }
  }
  // MARK: - Resent link methods
  func resendVerificationEmail(_ email: String, completion: @escaping (_ error: Error?) -> Void) {
    Auth.auth().currentUser?.reload { error in
      Auth.auth().currentUser?.sendEmailVerification { error in
        completion(error)
      }
    }
  }
  
  func resetPassword(withEmail email: String, completion: @escaping (_ error: Error?) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      completion(error)
    }
  }
  
  func logout(comletion: @escaping (_ error: Error?) -> Void) {
    do {
      try Auth.auth().signOut()
      userDefaults.removeObject(forKey: kCURRENTUSER)
      userDefaults.synchronize()
      comletion(nil)
    } catch { // let error as NSErrora
      comletion(error)
    }
    
  }
  // MARK: - Save persons
  func savePersonToFireStore(_ person: Person) {
    do {
      try FCollectionReference.reference(.person).document(person.id).setData(from: person)
    } catch {
      print(error.localizedDescription, "adding user")
    }
  }
  // MARK: - Download
  func downloadUserFromFirebase(userId: String, email: String? = nil) {
    FCollectionReference.reference(.person).document(userId).getDocument { querySnapshot, error in
      guard let document = querySnapshot else {
        print("no document for user")
        return
      }
      let result = Result {
        try? document.data(as: Person.self)
      }
      
      switch result {
      case .success(let person):
        if let person = person {
          Person.save(person)
        } else {
          print("Document does not exist")
        }
      case .failure(let error):
        print("Error decoding user \(error.localizedDescription)")
      }
    }
  }
  
  func downloadAllUsersFromFirebase(completion: @escaping ([Person]) -> Void) {
    var persons = [Person]()
    Firestore.firestore().collection("person").limit(to: 500).getDocuments { query, error in
      guard let documents = query?.documents else {
        print("no documents in all users")
        return
      }
      let allUsers = documents.compactMap {
        return try? $0.data(as: Person.self)
      }
      allUsers.forEach {
        if Person.currentId != $0.id {
          persons.append($0)
        }
      }
      completion(persons)
    }
  }
  
  func downloadUsersFromFirebase(withIds: [String], completion: @escaping ([Person]) -> Void) {
    
    var usersArray: [Person] = []
    for i in 0..<withIds.count {
      
      Firestore.firestore().collection("person").document(withIds[i]).getDocument { querySnapshot, error in
        
        guard let document = querySnapshot else {
          print("no document for user")
          return
        }
        
        if let person = try? document.data(as: Person.self) {
          usersArray.append(person)
        }
        if i == withIds.count - 1 {
          completion(usersArray)
        }
      }
    }
  }
}
