//
//  MainHeaderView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class MainHeaderView: UIStackView {
    
    // MARK: - Properties
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.justify"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var searchStack: UIStackView = {
        let searchTextField = CustomTextFieldStack(placeholder: "전체 범위에서 찾기", width: 215)
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = UIColor.black
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        
        stack.spacing = 2
        stack.distribution = .fillProportionally
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        [menuButton, searchStack].forEach { view in
            addArrangedSubview(view)
        }
        
        spacing = 54
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        setActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func menuButtonTapped() {
        
    }
    
    @objc func searchButtonTapped() {
        print("search button tapped")
    }
    
    // MARK: - Helpers
    
    func setActions() {
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
}
