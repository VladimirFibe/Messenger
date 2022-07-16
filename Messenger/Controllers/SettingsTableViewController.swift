//
//  SettingsTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 13.07.2022.
//

import UIKit
import ProgressHUD
class SettingsTableViewController: UITableViewController {
// MARK: - IBOutlets
  
  @IBOutlet weak var appVersionLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  // MARK: - View Life Cycle
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showUserInfo()
  }
  // MARK: - UpdateUI
  private func showUserInfo() {
    if let person = Person.currentPerson {
      usernameLabel.text = person.username
      statusLabel.text = person.status
      appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
      if person.avatar != "" {
        // download and set avatar image
        FileStorage.downloadImage(person: person) { image in
          if let image = image {
            self.avatarImageView.image = image.circleMasked
          } else {
            print("что то не так", person.avatar)
          }
        }
      }
    }
  }
  // MARK: - IBActions
  
  @IBAction func tellAFriendButtonPressed(_ sender: UIButton) {
    print(#function)
    
  }
  
  @IBAction func logoutButtonPressed(_ sender: UIButton) {
    FirebaseUserListener.shared.logout { error in
      if let error = error {
        ProgressHUD.showFailed(error.localizedDescription)
      } else {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginView")
        DispatchQueue.main.async {
          loginView.modalPresentationStyle = .fullScreen
          self.present(loginView, animated: true)
        }
      }
    }

  }
  @IBAction func termsAndContionsButtonPressed(_ sender: UIButton) {
    print(#function)

  }
  // MARK: - TableView Delegate
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(named: "TableViewBackgroundColor")
    return headerView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    section == 0 ? 0.0 : 10.0
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 0 && indexPath.row == 0 {
      performSegue(withIdentifier: "EditProfile", sender: self)
    }
  }
  
  
}
