//
//  FileView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

protocol FileHeaderViewDelegate: AnyObject {
    func dismissFileView()
}

class FileHeaderView: MainHeaderView {
    
    weak var delegate: FileHeaderViewDelegate?
    
    override init(icon: UIImage) {
        super.init(icon: icon)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        delegate?.dismissFileView()
    }
    
    // MARK: - Helpers
    override func setActions() {
        super.menuButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}
