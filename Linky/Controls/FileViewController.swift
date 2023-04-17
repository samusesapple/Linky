//
//  FileViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class FileViewController: UIViewController {

    // MARK: - Properties
    let headerView = FileHeaderView(icon: UIImage(systemName: "chevron.backward")!)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
    }
    
    // MARK: - Helpers

}

// MARK: - FileHeaderViewDelegate
extension FileViewController: FileHeaderViewDelegate {
    func dismissFileView() {
        dismiss(animated: true)
    }
    
    
}
