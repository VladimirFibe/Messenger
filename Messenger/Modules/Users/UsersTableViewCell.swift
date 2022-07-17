//
//  UsersTableViewCell.swift
//  Messenger
//
//  Created by Vladimir Fibe on 16.07.2022.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(with person: Person) {
    statusLabel.text = person.status
    usernameLabel.text = person.username
    setAvatar(person)
//    avatarImageView.image =
  }
  
  private func setAvatar(_ person: Person) {
    if person.avatar != "" {
      FileStorage.downloadImage(person: person) { image in
        self.avatarImageView.image = image?.circleMasked
      }
    }
  }
}
