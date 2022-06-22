//
//  FCollectionReference.swift
//  Messenger
//
//  Created by Vladimir Fibe on 22.06.2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
  case person
  case recent
  
  static func reference(_ collection: FCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collection.rawValue)
  }
}

