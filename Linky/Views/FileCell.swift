//
//  FileCell.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

protocol FileCellDelegate: AnyObject {
    func handleFileEdit()
    func presentFileView()
    func addNewFolder()
}

class FileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: FileCellViewModel? {
        didSet {
            showEditButtonIfFocused()
            setEmptyCell()
        }
    }
    
    weak var delegate: FileCellDelegate?
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "EditButtonColor")
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setDimensions(height: 28, width: 66)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var fileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9309713244, green: 0.9309713244, blue: 0.9309713244, alpha: 1)
        button.setDimensions(height: 190, width: 190)
        button.layer.cornerRadius = 15
        button.addSubview(fileButtonLabel)
        button.addTarget(self, action: #selector(fileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let fileButtonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        label.text = "🌴"
        label.setDimensions(height: 60, width: 60)
        return label
    }()
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "개발"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let fileNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "링크 5개"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [fileButton, fileNameLabel, fileNumberLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 12
        
        contentView.addSubview(stack)
        fileButtonLabel.centerX(inView: fileButton)
        fileButtonLabel.centerY(inView: fileButton)
        
        stack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 28 + 25)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func editButtonTapped() {
        delegate?.handleFileEdit()
    }
    
    @objc func fileButtonTapped() {
        if fileButtonLabel.text != " +"
        { delegate?.presentFileView() }
        else { delegate?.addNewFolder() }
    }
    
    // MARK: - Helper
    
    private func showEditButtonIfFocused() {
        guard viewModel?.isFocused == true else { return }

        contentView.addSubview(editButton)
        editButton.anchor(top: topAnchor)
        editButton.centerX(inView: self)
        needsUpdateConstraints()

    }
    
    private func setEmptyCell() {
        guard viewModel?.isEmpty == true else { return }
        fileButton.backgroundColor = .clear
        fileButtonLabel.font = UIFont.systemFont(ofSize: 60, weight: .ultraLight)
        fileButtonLabel.text = " +"
        fileNameLabel.text = ""
        fileNumberLabel.text = ""
        DispatchQueue.main.async { [weak self] in
            self?.fileButton.addDashedBorder()
        }
    }
    
}

