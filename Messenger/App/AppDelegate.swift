//
//  AppDelegate.swift
//  Messenger
//
//  Created by Vladimir Fibe on 19.06.2022.
//

import UIKit
import Firebase
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


  var firstRun: Bool?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    firstRunCheck()
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    return true
  }
// MARK: - First Run
  func firstRunCheck() {
    firstRun = UserDefaults.standard.bool(forKey: "firstRun")
    if let firstRun = firstRun, !firstRun {
      print("this is first run")
      let status = Status.allCases.map { $0.rawValue }
      UserDefaults.standard.set(status, forKey: kSTATUS)
      UserDefaults.standard.set(true, forKey: "firstRun")
      UserDefaults.standard.synchronize()
    } else { print("this is second run")}
  }
  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

