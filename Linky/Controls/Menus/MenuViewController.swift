//
//  MenuViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelected(menuItem: MenuViewController.MenuOptions)
}

final class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case privacy = "개인정보 처리방침"
        case library = "오픈소스 라이센스"
        case service = "문의하기"
        case appVersion = "앱 버전"
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.separatorStyle = .none
        tv.rowHeight = 60
        tv.backgroundColor = nil
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tv.frame.width, height: 80))
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width - 100, height: view.bounds.size.height)
    }
    
    
}
    // MARK: - UITableViewDelegate  UITableViewDataSource

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelected(menuItem: item)
    }
    
}
