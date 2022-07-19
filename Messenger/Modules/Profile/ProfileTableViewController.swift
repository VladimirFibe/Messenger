//
//  ProfileTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import UIKit

class ProfileTableViewController: UITableViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  // MARK: - Vars
  
  var person: Person?
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setupViews()
  }
  private func setupViews() {
    if let person = person {
      title = person.username
      statusLabel.text = person.status
      usernameLabel.text = person.username
      if person.avatar != "" {
        FileStorage.downloadImage(person: person) { image in
          self.avatarImageView.image = image?.circleMasked
        }
      }
    }
  }
  // MARK: - TableView Delegate
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = #colorLiteral(red: 0.949000001, green: 0.949000001, blue: 0.9689999819, alpha: 1)
    return headerView
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    4
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 1,
        let current = Person.currentPerson,
       let person = person
    {
      
      let chatId = startChat(person1: current, person2: person)
      let privateChatView = ChatViewController(chatId: chatId, recipientId: person.id, recipientName: person.username)
//      privateChatView.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(privateChatView, animated: true)
    }
  }
}
