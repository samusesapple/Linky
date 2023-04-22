//
//  FileCell.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

protocol FolderCellDelegate: AnyObject {
    func presentFolderView(folder: Folder)
    func addNewFolder()
    func presentAlertView(cell: FolderCell)
}

class FolderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: FolderCellViewModel? {
        didSet {
            configureUI()
            setEmptyCell()        }
    }
    
    weak var delegate: FolderCellDelegate?

    private let deleteButton = UIButton(type: .system)
    
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
        label.setDimensions(height: 60, width: 60)
        return label
    }()
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let fileNumberLabel: UILabel = {
        let label = UILabel()
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        fileButton.addGestureRecognizer(longPressRecognizer)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func fileButtonTapped() {
        if fileButtonLabel.text != " +"
        { delegate?.presentFolderView(folder: viewModel!.folder!) }
        else { delegate?.addNewFolder() }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        guard fileButton.backgroundColor != UIColor.clear else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        guard let folderID = viewModel?.folder?.folderID else { return }
        delegate?.presentAlertView(cell: self)
    }
    
    
    // MARK: - Helper
    
    private func configureUI() {
        guard viewModel?.isEmpty != true else { return }
        fileButtonLabel.text = viewModel?.icon
        fileNameLabel.text = viewModel?.title
        fileButton.backgroundColor = #colorLiteral(red: 0.9309713244, green: 0.9309713244, blue: 0.9309713244, alpha: 1)
        fileButton.layer.borderWidth = 0
        guard let links = viewModel?.linkCountString else { return }
        fileNumberLabel.text = links
 
    }
    
    private func setEmptyCell() {
        guard viewModel?.folder == nil else { return }
        fileButton.backgroundColor = .clear
        fileButtonLabel.font = UIFont.systemFont(ofSize: 60, weight: .ultraLight)
        fileButtonLabel.textColor = .gray
        fileButtonLabel.text = " +"
        fileNameLabel.text = ""
        fileNumberLabel.text = ""
        DispatchQueue.main.async { [weak self] in
            self?.fileButton.addDashedBorder()
        }
    }
    
    
}

