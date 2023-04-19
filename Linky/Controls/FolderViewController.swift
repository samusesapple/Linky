//
//  FileViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class FolderViewController: UIViewController {

    // MARK: - Properties
    private let headerView = HeaderSearchView(icon: UIImage(systemName: "chevron.backward")!)
    
    private let tableHeaderView: UIView = {
        let titleLabel = UILabel()
        titleLabel.text = "🌴" + " 개발"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
       let view = UIView()
        view.setDimensions(height: 100, width: 317)
        view.addSubview(titleLabel)
        titleLabel.centerY(inView: view)
        titleLabel.anchor(left: view.leftAnchor, paddingLeft: 15)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.rowHeight = 60
        tv.tableHeaderView = tableHeaderView
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(tableView)
        tableView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25)
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
