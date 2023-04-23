//
//  FileViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

protocol FolderViewControllerDelegate: AnyObject {
    func needsToUpdate()
}

class FolderViewController: UIViewController {

    // MARK: - Properties
    private var viewModel = FolderViewViewModel()
    weak var delegate: FolderViewControllerDelegate?
    
    private let headerView = HeaderSearchView(icon: UIImage(systemName: "chevron.backward")!)
    
    private let alignmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("과거순 ▲", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setDimensions(height: 17, width: 60)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(alignmentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView = UITableView()
    private let footerAddButton: UIButton = {
        let button = AddLinkButton(type: .system)
        button.addTarget(self, action: #selector(addLinkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    init(folder: Folder) {
        self.viewModel = FolderViewViewModel(folder: folder)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        view.addSubview(tableView)
        tableView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,paddingTop: 50, paddingLeft: 25, paddingBottom: 25, paddingRight: 25)

        view.addSubview(alignmentButton)
        alignmentButton.anchor(bottom: tableView.topAnchor, right: tableView.rightAnchor, paddingBottom: 13)
        
        view.addSubview(footerAddButton)
        footerAddButton.centerX(inView: view)
        footerAddButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 22)
        
        setTableView()
        configureUIWithData()
        setSwipeActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerView.delegate = self
    }
    
    // MARK: - Actions
    @objc func alignmentButtonTapped() {
        guard let link = viewModel.link else { return }
        if alignmentButton.titleLabel?.text == "최신순 ▼" {
            viewModel.sortLinkCurrentLast(link: link)
            alignmentButton.setTitle("과거순 ▲", for: .normal)
        }
        else if alignmentButton.titleLabel?.text == "과거순 ▲" {
            viewModel.sortLinkByKoreanLetter(link: link)
            alignmentButton.setTitle("가나다 ▼", for: .normal)
        } else {
            viewModel.sortLinkCurrentFirst(link: link)
            alignmentButton.setTitle("최신순 ▼", for: .normal)
        }
        tableView.reloadData()
    }
    
    @objc func addLinkButtonTapped() {
        let addVC = AddLinkViewController()
        addVC.delegate = self
        present(addVC, animated: true)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                self.navigationController?.popViewController(animated: true)
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setTableView() {
        tableView.backgroundColor = .clear
        tableView.rowHeight = 89 + 20
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.register(LinkCell.self, forCellReuseIdentifier: "linkCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUIWithData() {
        let stack = headerView.subviews[1] as! UIStackView
        let searchTextField = stack.arrangedSubviews[0] as! CustomTextFieldStack
        let tf = searchTextField.subviews[0] as! UITextField
        
        tf.placeholder = "'\(viewModel.folderIcon!) \(viewModel.folderTitle ?? "")' 에서 찾기"
    }
    
    private func setSwipeActions() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
    }
    
}

// MARK: - UITableViewDataSource
extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.link?.count ?? 0
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

        cell.viewModel = LinkCellViewModel(link: (viewModel.link?[indexPath.row])!)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddLinkViewController()
        addVC.delegate = self
        addVC.viewModel.folderTitle = viewModel.folderTitle
        addVC.viewModel.linkData = viewModel.link?[indexPath.row]
        present(addVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



// MARK: - HeaderSearchViewDelegate
extension FolderViewController: HeaderSearchViewDelegate {
    func handleLeftButtonActions() {
        navigationController?.popViewController(animated: true)
        delegate?.needsToUpdate()
    }
    
    func searchLink() {
        print("FolderVC - search button tapped")
    }
    
}

// MARK: - AddLinkViewControllerDelegate
extension FolderViewController: AddLinkViewControllerDelegate {
    func updateLink(controller: AddLinkViewController, link: Link) {
        if link.urlString == controller.viewModel.linkData?.urlString {
            viewModel.updateLink(link: link)
        } else { controller.viewModel.createLink(link: link) }
        
        tableView.reloadData()
    }
    
}
