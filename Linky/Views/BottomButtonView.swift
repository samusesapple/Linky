//
//  BottomButtonView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class BottomButtonView: UIStackView {

    private let addButton: UIButton = {
       let button = UIButton()
        button.tintColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.3)
        button.backgroundColor = UIColor(named: "MainGreenColor")
        button.setDimensions(height: 65, width: 65)
        button.clipsToBounds = false
        button.layer.cornerRadius = 65 / 2
        button.setupShadow(opacity: 0.3, radius: 0.7, offset: CGSize(width: 0.5, height: 1.0), color: .black)
        return button
    }()
    
    private let plusButtonImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate))
        iv.setDimensions(height: 25, width: 25)
        iv.tintColor = UIColor(white: 1, alpha: 0.9)
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 65).isActive = true
        addButton.addSubview(plusButtonImage)
        plusButtonImage.centerX(inView: addButton)
        plusButtonImage.centerY(inView: addButton)
        
        [UIView(), addButton, UIView()].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .fillProportionally
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        setActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func addButtonTapped() {
        print("add button tapped")
    }
    
    // MARK: - Helpers
    
    func setActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
}
