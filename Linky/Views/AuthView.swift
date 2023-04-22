//
//  AuthView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

protocol AuthViewDelegate: AnyObject {
    func handleLogin()
}

class AuthView: UIView {

    // MARK: - Propreties
    
    weak var delegate: AuthViewDelegate?
    
    let idTextField = CustomTextField(placeholder: "User ID")
    let passwordTextField = CustomTextField(placeholder: "Password", isSecuredText: true)
    
    let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        idTextField.backgroundColor = UIColor(named: "EditButtonColor")
        idTextField.borderStyle = .roundedRect

        passwordTextField.backgroundColor = UIColor(named: "EditButtonColor")
        passwordTextField.borderStyle = .roundedRect
        
        loginButton.setTitle("로그인", for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [idTextField, passwordTextField, loginButton])
        stack.setDimensions(height: 187, width: 273)
        stack.axis = .vertical
        stack.spacing = 26
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.centerX(inView: self)
        stack.centerY(inView: self)
        
        setButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func loginButtonTapped() {
        print(#function)
//        delegate?.handleLogin()
    }
    
    
    // MARK: - Helpers
    
    func setButtonActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
}
