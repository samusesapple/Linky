//
//  ViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let headerView = MainHeaderView()
    private let bottomView = BottomButtonView()
    
    private let collectionView = FileCollectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        addEditButton()
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.centerX(inView: view)
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22).isActive = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: bottomView.topAnchor, trailing: view.trailingAnchor)
    }
    
    func addEditButton() {
         let editButton: UIButton = {
            let button = UIButton(type: .system)
             button.backgroundColor = UIColor(named: "EditButtonColor")
            button.titleLabel?.text = "Edit"
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = .black
             button.clipsToBounds = true
             button.layer.cornerRadius = 5
            button.setDimensions(height: 28, width: 66)
           return button
        }()

        view.addSubview(editButton)
        editButton.anchor(top: headerView.bottomAnchor, paddingTop: 150)
        editButton.centerX(inView: view)

    }
    
}



