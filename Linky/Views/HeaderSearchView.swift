//
//  MainHeaderView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

protocol HeaderSearchViewDelegate: AnyObject {
    func handleLeftButtonActions()
    func searchLink()
}

class HeaderSearchView: UIStackView {
    
    // MARK: - Properties
    
    weak var delegate: HeaderSearchViewDelegate?
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
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
    
    init(icon: UIImage) {
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        leftButton.setImage(icon, for: .normal)
        [leftButton, searchStack].forEach { view in
            addArrangedSubview(view)
        }
        
        spacing = 54
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 30, bottom: 0, right: 30)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func leftButtonTapped() {
        delegate?.handleLeftButtonActions()
    }
    
    @objc func searchButtonTapped() {
        delegate?.searchLink()
    }
    
    // MARK: - Helpers
    

    
}
