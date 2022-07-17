//
//  RecentTableViewCell.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

  // MARK: - IBOutlets
  @IBOutlet weak var unreadBackgroundView: UIView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var lastmessageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
    unreadBackgroundView.layer.cornerRadius = unreadBackgroundView.frame.height / 2
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func configure(with recent: RecentChat) {
    usernameLabel.text = recent.receiverName
    usernameLabel.adjustsFontSizeToFitWidth = true
    usernameLabel.minimumScaleFactor = 0.9
    
    lastmessageLabel.text = recent.lastMessage
    lastmessageLabel.adjustsFontSizeToFitWidth = true
    lastmessageLabel.minimumScaleFactor = 0.9
    lastmessageLabel.numberOfLines = 2
    counterLabel.text = "\(recent.undreadCounter)"
    unreadBackgroundView.isHidden = recent.undreadCounter == 0
    setAvatar(recent.person)
    dateLabel.text = recent.timeElapsed
    dateLabel.adjustsFontSizeToFitWidth = true
  }
  
  private func setAvatar(_ person: Person) {
    if person.avatar != "" {
      FileStorage.downloadImage(person: person) { image in
        self.avatarImageView.image = image?.circleMasked
      }
    }
  }
}
