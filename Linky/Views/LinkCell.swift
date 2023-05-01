//
//  LinkCell.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/20.
//

import UIKit
import LinkPresentation

protocol LinkCellDelegate: AnyObject {
    func needToResetTableView()
    func needToShowToast(message: String)
}

class LinkCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel = LinkCellViewModel() {
        didSet {
            configureUI()
        }
    }
    
    weak var delegate: LinkCellDelegate?
    
    private let imageButton: UIButton = {
        let imageView = UIImageView(image: UIImage(systemName: "cursorarrow.click.2")?.withRenderingMode(.alwaysTemplate))
        imageView.setDimensions(height: 25, width: 25)
        imageView.tintColor = .systemGray2
        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "LinkyLabelImage")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addSubview(imageView)
        imageView.anchor(bottom:button.bottomAnchor, right: button.rightAnchor)
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let linkTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.setDimensions(height: 15, width: 190)
        label.text = "설정한 링크 제목"
        return label
    }()
    
    private let linkDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.setDimensions(height: 13, width: 200)
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "EditButtonColor")
        
        contentView.addSubview(imageButton)
        imageButton.centerY(inView: contentView)
        imageButton.anchor(left: contentView.leftAnchor, paddingLeft: 14)
        imageButton.setDimensions(height: 75, width: 75)
        
        contentView.addSubview(linkTitleLabel)
        linkTitleLabel.anchor(top: contentView.topAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingRight: 23)
        
        contentView.addSubview(linkDescriptionLabel)
        linkDescriptionLabel.anchor(bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 15, paddingRight: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Actions
    @objc func imageButtonTapped() {
        if let url = URL(string: (viewModel.linkURLString)!) {
            UIApplication.shared.open(url)
        } else {
            delegate?.needToShowToast(message: "존재하지 않는 URL 입니다.")
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        linkTitleLabel.text = viewModel.title
        linkDescriptionLabel.text = viewModel.linkURLString
        
        // 메타데이터 받아서 그 안의 이미지 캐싱하여 업로드 필요
        guard let urlString = viewModel.linkURLString else { return }
        viewModel.setMetadataImage(urlString: urlString, sender: imageButton)
        
    }
    

    
}

