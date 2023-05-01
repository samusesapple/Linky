//
//  SearchViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func resetCollectionView()
}

final class SearchResultViewController: UISearchController {
    
    var viewModel = FolderViewViewModel() {
        didSet {
            configureUIWithData()
        }
    }
    
    weak var customDelegate: SearchResultViewControllerDelegate?
    
    private lazy var tableView = UITableView()
    
    private var linkCountLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController

        
        view.addSubview(tableView)

        tableView.backgroundColor = .clear
        tableView.rowHeight = 89 + 20
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.register(LinkCell.self, forCellReuseIdentifier: "linkCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 25, paddingRight: 25)
        
        view.addSubview(linkCountLabel)
        linkCountLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        linkCountLabel.centerX(inView: view)
        
        view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        customDelegate?.resetCollectionView()
    }
    
    // MARK: - Helpers
    
    func configureUIWithData() {
        guard let count = viewModel.links?.count else { return }
        linkCountLabel.text = "관련 링크 \(count)개"
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.links?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as! LinkCell
        
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor(named: "EditButtonColor")?.withAlphaComponent(CGFloat(0.1))
        backgroundColorView.layer.cornerRadius = 17
        backgroundColorView.clipsToBounds = true
        
        cell.selectedBackgroundView = backgroundColorView
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 10

        cell.viewModel = LinkCellViewModel(link: (viewModel.links?[indexPath.row])!)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddLinkViewController()
        addVC.delegate = self
        addVC.viewModel.linkData = viewModel.links?[indexPath.row]
        present(addVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - AddLinkViewControllerDelegate
extension SearchResultViewController: AddLinkViewControllerDelegate {
    func updateLink(link: Link) {
        tableView.reloadData()
    }
    
    
}
