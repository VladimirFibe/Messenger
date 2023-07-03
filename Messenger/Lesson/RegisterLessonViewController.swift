import UIKit
import PhotosUI

final class RegisterLessonViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let firstnameField = UITextField()
    private let lastnameField = UITextField()
    private let usernameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let registerButton = UIButton(type: .system)
    
    @objc private func registerButtonTapped() {
        print("Register")
    }
    
    @objc private func didTapChangeProfilePicture() {
        presentPhotoPicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

extension RegisterLessonViewController {
    override func setupViews() {
        super.setupViews()
        title = "Register"
        setupScrollView()
        setupImageView()
        setupFirstnameField()
        setupLastnameField()
        setupUsernameField()
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
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupFirstnameField() {
        scrollView.addSubview(firstnameField)
        firstnameField.autocapitalizationType = .none
        firstnameField.autocorrectionType = .no
        firstnameField.returnKeyType = .continue
        firstnameField.layer.cornerRadius = 12
        firstnameField.layer.borderWidth = 1
        firstnameField.layer.borderColor = UIColor.lightGray.cgColor
        firstnameField.placeholder = "First name..."
        firstnameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstnameField.leftViewMode = .always
        firstnameField.backgroundColor = .secondarySystemBackground
        firstnameField.delegate = self
    }
    
    private func setupLastnameField() {
        scrollView.addSubview(lastnameField)
        lastnameField.autocapitalizationType = .none
        lastnameField.autocorrectionType = .no
        lastnameField.returnKeyType = .continue
        lastnameField.layer.cornerRadius = 12
        lastnameField.layer.borderWidth = 1
        lastnameField.layer.borderColor = UIColor.lightGray.cgColor
        lastnameField.placeholder = "Last name..."
        lastnameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastnameField.leftViewMode = .always
        lastnameField.backgroundColor = .secondarySystemBackground
        lastnameField.delegate = self
    }
    
    private func setupUsernameField() {
        scrollView.addSubview(usernameField)
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.returnKeyType = .continue
        usernameField.layer.cornerRadius = 12
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        usernameField.placeholder = "Username..."
        usernameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        usernameField.leftViewMode = .always
        usernameField.backgroundColor = .secondarySystemBackground
        usernameField.delegate = self
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
        scrollView.addSubview(registerButton)
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .link
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .primaryActionTriggered)
    }
    
    private func setupFrames() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        firstnameField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        lastnameField.frame = CGRect(x: 30,
                                  y: firstnameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        usernameField.frame = CGRect(x: 30,
                                  y: lastnameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: usernameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        registerButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
    }
}

extension RegisterLessonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameField {
            lastnameField.becomeFirstResponder()
        } else if textField == lastnameField {
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterLessonViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.imageView.image == previousImage else { return }
                    self.imageView.image = image
                }
            }
        }
    }
    
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}
