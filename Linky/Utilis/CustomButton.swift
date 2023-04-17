//
//  AuthButton.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class CustomButton: UIButton {

    init(height: CGFloat, color: UIColor, titleColor: UIColor, enabled: Bool) {

        super.init(frame: .zero)
        backgroundColor = color
        setupShadow(opacity: 0.2, radius: 0.3, offset: CGSize(width: 1.0, height: 1.0), color: .black)
        layer.cornerRadius = 7
        heightAnchor.constraint(equalToConstant: height).isActive = true
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        isEnabled = enabled
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.8)
        layer.cornerRadius = 7
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        setTitleColor(.white, for: .normal)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
