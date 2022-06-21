//
//  ViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 19.06.2022.
//

import UIKit
import ProgressHUD

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
  
  // MARK: - Vars
  
  var isLogin = true
  
  // MARK: - View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextFieldDelegates()
    setupBackgroundTap()
    updateUIFor(login: true)
    loginButton.setTitle("", for: .normal)
  }

  // MARK: - Actions
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    if isDataInputedFor(type: isLogin ? "login" : "registration") {
      print(#function)
    } else {
      ProgressHUD.showFailed("All Fields are required!")
    }
  }
  
  @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
    if isDataInputedFor(type: "password") {
      print(#function)
    } else {
      ProgressHUD.showFailed("Email is required.")
    }
  }
  
  @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
    if isDataInputedFor(type: "password") {
      print(#function)
    } else {
      ProgressHUD.showFailed("Email is required.")
    }
  }
  
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    updateUIFor(login: sender.titleLabel?.text == "Login")
    isLogin.toggle()
  }
  
  // MARK: - Setup
  private func setupTextFieldDelegates() {
    emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
  }
  
  @objc func textFieldDidChanged(_ textField: UITextField) {
    updatePlaceholderLabels(textField: textField)
  }
  
  private func setupBackgroundTap() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func backgroundTap() {
    view.endEditing(false)
  }
  // MARK: Animations
  
  private func updateUIFor(login: Bool) {
    loginButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
    signUpButton.setTitle(login ? "Sign Up" : "Login", for: .normal)
    signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
    
    UIView.animate(withDuration: 0.5) {
      self.repeatPasswordLineView.isHidden = login
      self.repeatPasswordLabel.isHidden = login
      self.repeatPasswordTextField.isHidden = login
    }
  }
  private func updatePlaceholderLabels(textField: UITextField) {
    switch textField {
    case emailTextField: emailLabel.text = textField.hasText ? "Email" : ""
    case passwordTextField: passwordLabel.text = textField.hasText ? "Password" : ""
      default: repeatPasswordLabel.text = textField.hasText ? "Repeat Password" : ""
    }
  }
  
  // MARK: - Helpers
  
  private func isDataInputedFor(type: String) -> Bool {
    let result = emailTextField.text != "" && passwordTextField.text != ""
    switch type {
    case "login": return result
    case "registration": return result && repeatPasswordTextField.text != ""
    default: return emailTextField.text != ""
    }
  }
}

