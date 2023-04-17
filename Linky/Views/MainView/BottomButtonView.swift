//
//  BottomButtonView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

protocol BottomButtonViewDelegate: AnyObject {
    func handleAddButtonAction()
}

class BottomButtonView: UIStackView {

    weak var delegate: BottomButtonViewDelegate?
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "MainGreenColor")
        button.setDimensions(height: 65, width: 65)
        button.clipsToBounds = false
        button.layer.cornerRadius = 65 / 2
        button.setupShadow(opacity: 0.3, radius: 0.7, offset: CGSize(width: 0.5, height: 1.0), color: .black)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return button
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 65).isActive = true

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
        delegate?.handleAddButtonAction()
    }
    
    // MARK: - Helpers
    
    func setActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
}
