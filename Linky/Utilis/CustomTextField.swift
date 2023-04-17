//
//  CustomTextField.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit


final class CustomTextField: UITextField {
    
    init(placeholder: String, isSecuredText: Bool? = false) {
        super.init(frame: .zero)
        
        let space = UIView()
        space.setDimensions(height: 38, width: 8)
        leftView = space
        leftViewMode = .always
        borderStyle = .none
        textColor = .black
        font = UIFont.systemFont(ofSize: 17)
        
        autocapitalizationType = .none
        keyboardAppearance = .dark
        clearButtonMode = .whileEditing
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        isSecureTextEntry = isSecuredText!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


final class CustomTextFieldStack: UIStackView {
    
    private var placeholder: String
    private var lineWidth: Double
    
    
    init(placeholder: String, width: Double) {
        self.placeholder = placeholder
        self.lineWidth = width
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        let textField = CustomTextField(placeholder: placeholder)
        let textFieldBottomLine = UIView()
        
        textFieldBottomLine.setDimensions(height: 3, width: lineWidth)
        textFieldBottomLine.backgroundColor = UIColor(named: "MainGreenColor")
        textFieldBottomLine.clipsToBounds = true
        textFieldBottomLine.layer.cornerRadius = 3
        
        [textField, textFieldBottomLine].forEach { view in
            addArrangedSubview(view)
        }
        axis = .vertical
        spacing = 3
        distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}