//
//  LoginViewController.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import UIKit
import SwiftUI
import CoreLocation

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    lazy var emailLabel = makeLabel(text: "e-mail")
    lazy var emailTextField = makeTextField(placeholder: "e-mail")
    lazy var passwordLabel = makeLabel(text: "Пароль")
    lazy var passwordTextField = makeTextField(placeholder: "******")
    
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.buttonBackgroundColor
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
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
        navigationItem.title = "Вход"
        view.backgroundColor = .systemBackground
        
        requestLocationPermission()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.autocapitalizationType = .none
        }
    }
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            print("Requesting location authorization...")
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            print("Current location saved")
        } else {
            print("Location permission denied.")
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
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
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
