//
//  AuthButton.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

final class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "MainGreenColor")
        layer.cornerRadius = 15
        setTitleColor(.black, for: .normal)
        isEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

final class AddLinkButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tintColor = .white
        setDimensions(height: 60, width: 60)
        layer.cornerRadius = 60 / 2
        setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.2585691512, green: 0.7276339531, blue: 0.7204007506, alpha: 1)
        let rightColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 3, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)

        clipsToBounds = true
        
        gradientLayer.frame = rect
    }

}
