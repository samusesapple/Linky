//
//  MainView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class MainView: UIView {
    
    // MARK: - Properties
    private let headerView = MainHeaderView()
    
    private let addButton: UIButton = {
       let button = UIButton()
        button.tintColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.3)
        button.backgroundColor = UIColor(named: "MainGreenColor")
        button.setDimensions(height: 65, width: 65)
        button.clipsToBounds = false
        button.layer.cornerRadius = 65 / 2
        button.setupShadow(opacity: 0.7, radius: 0.7, offset: CGSize(width: 0.5, height: 1.0), color: .black)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func addButtonTapped() {
        print("button tapped")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        self.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerX(inView: self)
        addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -22).isActive = true
    }
}
