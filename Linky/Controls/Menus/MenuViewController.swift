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
    
    // MARK: - Properties
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case privacy = "개인정보 처리방침"
        case library = "오픈소스 라이센스"
        case service = "문의하기"
        case appVersion = "앱 버전"
    }
    
    private let accountButton: UIButton = {
        let label = UILabel()
        label.text = "Google 계정"
        label.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        let button = CustomButton(type: .system)
        button.backgroundColor = UIColor(named: "EditButtonColor")
        button.setDimensions(height: 91, width: 271)
        button.addSubview(label)
        label.anchor(top: button.topAnchor, left: button.leftAnchor, paddingTop: 10, paddingLeft: 15)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tv.frame.width, height: 220))
        headerView.addSubview(accountButton)
        accountButton.centerX(inView: headerView)
        accountButton.anchor(bottom: headerView.bottomAnchor, paddingBottom: 50)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.rowHeight = 60
        tv.tableHeaderView = headerView
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        accountButton.setTitle("gwansammy@gmail.com", for: .normal)
        accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width - 90, height: view.bounds.size.height)
    }
    
    // MARK: - Actions
    @objc func accountButtonTapped() {
//        if let url = URL(string: (accountButton.titleLabel?.text)!) {
//          UIApplication.shared.open(url)
//        } else {
//          print("url is not correct")
//        }
    }
    

    
    // MARK: - Helpers
    
    
}
    // MARK: - UITableViewDelegate  UITableViewDataSource

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor(named: "EditButtonColor")?.withAlphaComponent(CGFloat(0.1))
        backgroundColorView.layer.cornerRadius = 17
        backgroundColorView.clipsToBounds = true
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .center
        cell.selectedBackgroundView = backgroundColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelected(menuItem: item)
    }
    
}
