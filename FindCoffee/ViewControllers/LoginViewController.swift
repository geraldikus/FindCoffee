//
//  LoginViewController.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    lazy var emailLabel = makeLabel(text: "e-mail")
    lazy var emailTextField = makeTextField(placeholder: "e-mail")
    lazy var passwordLabel = makeLabel(text: "Пароль")
    lazy var passwordTextField = makeTextField(placeholder: "******")
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.buttonBackgroundColor
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private let emailStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private let passwordStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private let loginStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 20
        
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Регистрация"
        view.backgroundColor = .systemBackground
        
        setupStuck()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        keyboardAnimation()
        
        view.addSubview(loginStackView)
    }
    
    private func setupStuck() {
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        passwordStackView.addArrangedSubview(loginButton)
        
        loginStackView.addArrangedSubview(emailStackView)
        loginStackView.addArrangedSubview(passwordStackView)
    }
    
    private func setupConstraints() {
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(loginStackView)
            make.height.equalTo(47)
        }

        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(emailTextField)
            make.height.equalTo(47)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(passwordTextField)
            make.height.equalTo(47)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if emailTextField.isEmailValid {
            emailLabel.text = "e-mail"
        } else {
            emailLabel.text = "Неверный email"
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    private func keyboardAnimation() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardFrame.height / 2.5
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

}

// MARK: - For Canvas

struct ViewRepresetLogin: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewRepresetLogin>) {
        
    }
    
}

struct CanvasViewLogin: View {
    var body: some View {
        ViewRepresetLogin()
    }
}

#Preview {
    CanvasViewLogin()
}
