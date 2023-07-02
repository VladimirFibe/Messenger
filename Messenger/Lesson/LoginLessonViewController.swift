import UIKit

final class LoginLessonViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    
    @objc private func didTapRegister() {
         let vc = RegisterLessonViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, password.count > 5 else {
            alertUserLoginError()
            return
        }
        print("Log In")
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please, enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

extension LoginLessonViewController {
    override func setupViews() {
        super.setupViews()
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                     style: .done, target: self, action: #selector(didTapRegister))
        setupScrollView()
        setupImageView()
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.clipsToBounds = true
    }
    
    private func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupEmailField() {
        scrollView.addSubview(emailField)
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.placeholder = "Email Address..."
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .secondarySystemBackground
        emailField.delegate = self
    }
    
    private func setupPasswordField() {
        scrollView.addSubview(passwordField)
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.placeholder = "Password..."
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .secondarySystemBackground
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
    }
    
    private func setupLoginButton() {
        scrollView.addSubview(loginButton)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .link
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .primaryActionTriggered)
    }
    
    private func setupFrames() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        loginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
    }
}

extension LoginLessonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
