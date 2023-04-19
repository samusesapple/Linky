//
//  AuthButton.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "MainGreenColor")
        layer.cornerRadius = 7
        setTitleColor(.black, for: .normal)
        isEnabled = true
    }
    
    //    init(height: CGFloat, color: UIColor, titleColor: UIColor, enabled: Bool) {
//        super.init(frame: .zero)
//        backgroundColor = color
//        layer.cornerRadius = 7
//        heightAnchor.constraint(equalToConstant: height).isActive = true
//        setTitleColor(titleColor, for: .normal)
//        titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        isEnabled = enabled
//    }

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

//class AddLinksButton: UIButton {
//
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//
//        tintColor = .white
//        backgroundColor = UIColor(named: "MainGreenColor")
//        setDimensions(height: 65, width: 65)
//        clipsToBounds = false
//        layer.cornerRadius = 65 / 2
//        setupShadow(opacity: 0.3, radius: 0.7, offset: CGSize(width: 0.5, height: 1.0), color: .black)
//        setImage(UIImage(systemName: "plus"), for: .normal)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

class AddLinkButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tintColor = .white
        setDimensions(height: 65, width: 65)
        layer.cornerRadius = 65 / 2
        setImage(UIImage(systemName: "plus"), for: .normal)
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
