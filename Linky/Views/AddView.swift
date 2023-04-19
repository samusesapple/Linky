//
//  AddView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

protocol AddViewDelegate: AnyObject {
    func selectFolder()
    func handleBackButton()
    func handleSaveButton()
}

class AddView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AddViewDelegate?
    
    private let viewTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "링크 추가"
        label.font = UIFont.systemFont(ofSize: 16)
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return label
    }()
    
    private let folderButton: UIButton = {
        let button = CustomButton(type: .system)
        button.backgroundColor = UIColor(named: "EditButtonColor")
        button.titleLabel?.textColor = .darkGray
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let linkInputTextField = CustomTextFieldStack(placeholder: "링크를 입력해주세요", width: 272)
    
    private let memoTextField: UITextView = {
       let tv = UITextView()
        tv.setDimensions(height: 123, width: 272)
        tv.layer.borderWidth = 3
        tv.layer.borderColor = UIColor(named: "MainGreenColor")?.cgColor
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    private let backButton: UIButton = {
        let button = CustomButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.backgroundColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.5)
        return button
    }()
    private let saveButton: UIButton = {
        let button = CustomButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.titleLabel?.textColor = .white
        return button
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(viewTitleLabel)
        viewTitleLabel.anchor(top: topAnchor, paddingTop: 30)
        viewTitleLabel.centerX(inView: self)
        
        folderButton.setTitle("기본 폴더", for: .normal)
        let viewStack = UIStackView(arrangedSubviews: [folderButton, linkInputTextField, memoTextField])
        viewStack.axis = .vertical
        viewStack.spacing = 60
        viewStack.distribution = .equalSpacing
        
        addSubview(viewStack)
        viewStack.anchor(top: viewTitleLabel.bottomAnchor, paddingTop: 45)
        viewStack.centerX(inView: self)
        
        backButton.setTitle("취소", for: .normal)
        saveButton.setTitle("저장", for: .normal)
        let buttonStack = UIStackView(arrangedSubviews: [backButton, saveButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.setDimensions(height: 90 + 20, width: 272)
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 100)
        setButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc func folderButtonTapped() {
        delegate?.selectFolder()
    }
    
    @objc func backButtonTapped() {
        delegate?.handleBackButton()
    }
    
    @objc func saveButtonTapped() {
        delegate?.handleSaveButton()
    }
    
    // MARK: - Helpers

    func setButtonActions() {
        folderButton.addTarget(self, action: #selector(folderButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    
}

