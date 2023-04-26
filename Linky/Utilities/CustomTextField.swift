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
        font = UIFont.systemFont(ofSize: 16)
        
        autocapitalizationType = .none
        returnKeyType = .done
        keyboardAppearance = .light
        clearButtonMode = .whileEditing
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 15
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        isSecureTextEntry = isSecuredText!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class EmojiTextField: UITextField {

    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
