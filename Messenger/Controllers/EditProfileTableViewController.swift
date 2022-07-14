//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 13.07.2022.
// EditProfile

import UIKit
import Gallery
import ProgressHUD
class EditProfileTableViewController: UITableViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var statusLabel: UILabel!
  
  // MARK: - Vars
  var gallery: GalleryController!
  
  // MARK: - View Life Circle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureTextField()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showUserInfo()
  }
  // MARK: - Update UI
  private func showUserInfo() {
    if let person = Person.currentPerson {
      usernameTextField.text = person.username
      statusLabel.text = person.status
    }
  }
  // MARK: - Configure
  func configureTextField() {
    usernameTextField.delegate = self
    usernameTextField.clearButtonMode = .whileEditing
  }
  
  func showImageGallery() {
    self.gallery = GalleryController()
    self.gallery.delegate = self
    
    Config.tabsToShow = [.imageTab, .cameraTab]
    Config.Camera.imageLimit = 1
    Config.initialTab = .imageTab
    
    self.present(gallery, animated: true, completion: nil)
  }
  // MARK: - Actions
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    showImageGallery()
  }
  
  // MARK: -
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    section == 0 ? 0.0 : 30.0
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO: show status view
  }
}

extension EditProfileTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTextField,
        textField.text != "",
       var person = Person.currentPerson {
      person.username = textField.text!
      Person.save(person)
      FirebaseUserListener.shared.savePersonToFireStore(person)
      textField.resignFirstResponder()
      return false
    }
    return true
  }
}

extension EditProfileTableViewController: GalleryControllerDelegate {
  func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
    controller.dismiss(animated: true)
    if let image = images.first {
      image.resolve { avatarImage in
        if let avatarImage = avatarImage {
          // TODO: upload image
          self.avatarImageView.image = avatarImage
        } else {
          ProgressHUD.showFailed("нет изображения")
        }
      }
    }
  }
  
  func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
    controller.dismiss(animated: true)

  }
  
  func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
    controller.dismiss(animated: true)

  }
  
  func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
    controller.dismiss(animated: true)
  }
  
  
}
