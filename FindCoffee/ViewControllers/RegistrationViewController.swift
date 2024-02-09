//
//  ViewController.swift
//  FindCoffee
//
//  Created by Anton on 02.02.24.
//

import UIKit
import SnapKit
import SwiftUI

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    lazy var emailLabel = makeLabel(text: "e-mail")
    lazy var emailTextField = makeTextField(placeholder: "e-mail")
    lazy var passwordLabel = makeLabel(text: "Пароль")
    lazy var passwordTextField = makeTextField(placeholder: "******")
    lazy var repeatPasswordLabel = makeLabel(text: "Повторите пароль")
    lazy var repeatPasswordTextField = makeTextField(placeholder: "******")
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private let repeatPasswordStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.buttonBackgroundColor
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let registrationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Регистрация"
        view.backgroundColor = .systemBackground
        
        setupView()
        setupStack()
        setupConstraints()
    }
    
    private func setupView() {
     //   passwordTextField.isSecureTextEntry = true

        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        keyboardAnimation()
        
        view.addSubview(registrationStackView)
    }
    
    private func setupStack() {
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        repeatPasswordStackView.addArrangedSubview(repeatPasswordLabel)
        repeatPasswordStackView.addArrangedSubview(repeatPasswordTextField)
        
        registrationStackView.addArrangedSubview(emailStackView)
        registrationStackView.addArrangedSubview(passwordStackView)
        registrationStackView.addArrangedSubview(repeatPasswordStackView)
        registrationStackView.addArrangedSubview(registrationButton)
    }
    
    private func setupConstraints() {

        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(emailStackView)
            make.height.equalTo(47)
        }

        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(passwordStackView)
            make.height.equalTo(47)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.width.equalTo(repeatPasswordStackView)
            make.height.equalTo(47)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.width.equalTo(repeatPasswordStackView)
            make.height.equalTo(47)
        }
        
        registrationStackView.snp.makeConstraints { make in
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
        repeatPasswordTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.autocapitalizationType = .none
        }
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
    
    @objc func registrationButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Network.shared.register(email: email, password: password) { result in
            switch result {
            case .success:
                self.login(email: email, password: password)
                print("Register success")
            case .failure(let error):
                print("Registration failed with error: \(error)")
            }
        }
    }

    private func login(email: String, password: String) {
        Network.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let authResponse):
                print("Login succes")
                DispatchQueue.main.async {
                    let nearestCoffeeShopsViewController = NearestCoffeeShopsViewController(token: authResponse.token)
                    self.navigationController?.pushViewController(nearestCoffeeShopsViewController, animated: true)
                }
            case .failure(let error):
                print("Authentication failed with error: \(error)")
            }
        }
    }
}

// MARK: - For Canvas

//struct ViewRepreset: UIViewControllerRepresentable {
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        return RegistrationViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewRepreset>) {
//        
//    }
//    
//}
//
//struct CanvasView: View {
//    var body: some View {
//        ViewRepreset()
//    }
//}
//
//#Preview {
//    CanvasView()
//}

