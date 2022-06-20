//
//  ViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 19.06.2022.
//

import UIKit

class LoginViewController: UIViewController {

  // MARK: - IBOutlets
  // labels
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var repeatPasswordLabel: UILabel!
  @IBOutlet weak var signUpLabel: UILabel!
  
  // textfields
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  // buttons
  @IBOutlet weak var resendEmailButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  // views
  @IBOutlet weak var repeatPasswordLineView: UIView!
  
  // MARK: - View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
  }
}

