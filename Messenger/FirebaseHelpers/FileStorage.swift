//
//  FileStorage.swift
//  Messenger
//
//  Created by Vladimir Fibe on 14.07.2022.
//

import Foundation
import FirebaseStorage
import ProgressHUD

class FileStorage {
  // MARK: - Images
  class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
    let storageRef = Storage.storage().reference().child(directory)
    guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
    var task: StorageUploadTask!
    task = storageRef.putData(imageData) { metadata, error in
      task.removeAllObservers()
      ProgressHUD.dismiss()
      if let error = error {
        print("error uploading image \(error.localizedDescription)")
        return
      }
      storageRef.downloadURL { url, error in
        guard let url = url else { return }
        completion(url.absoluteString)
      }
      
    }
    task.observe(StorageTaskStatus.progress) { snapshot in
      let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
      ProgressHUD.showProgress(CGFloat(progress))
    }
  }
  // MARK: - Save Locally
  class func saveFileLocally(fileData: NSData, fileName: String) {
    let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
    fileData.write(to: docUrl, atomically: true)
  }
  
}

// Helpers

func getDocumentsURL() -> URL {
  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumetsDirectory(fileName: String) -> String {
  getDocumentsURL().appendingPathComponent(fileName).path
}

func fileExistsAtPath(_ path: String) -> Bool {
  FileManager.default.fileExists(atPath: fileInDocumetsDirectory(fileName: path))
}
