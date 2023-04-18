//
//  FileViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class FolderViewController: UIViewController {

    // MARK: - Properties
    let headerView = HeaderSearchView(icon: UIImage(systemName: "chevron.backward")!)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerView.delegate = self
    }
    
    // MARK: - Helpers


    
}

// MARK: - HeaderSearchViewDelegate
extension FolderViewController: HeaderSearchViewDelegate {
    func handleLeftButtonActions() {
        navigationController?.popViewController(animated: true)
    }
    
    func searchLink() {
        print("FileVC - search button tapped")
    }
    
    
}
