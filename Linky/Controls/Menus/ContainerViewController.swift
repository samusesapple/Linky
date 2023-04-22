//
//  ContainerViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import UIKit
import RealmSwift
import Realm

final class ContainerViewController: UIViewController {
    
    private enum MenuState {
        case opened
        case closed
    }
    
    // MARK: - Properties
    
    private var menuState: MenuState = .closed
    
    private let mainVC = MainViewController()
    private let menuVC = MenuViewController()
    private var navVC: UINavigationController?
    private lazy var privacyVC = PrivacyViewController()
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChildVC()
//        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//
//                let realmURLs = [
//
//                    realmURL,
//
//                    realmURL.appendingPathExtension("lock"),
//
//                    realmURL.appendingPathExtension("note"),
//
//                    realmURL.appendingPathExtension("management")
//
//                ]
//
//                for URL in realmURLs {
//
//                    do {
//
//                        try FileManager.default.removeItem(at: URL)
//
//                    } catch {
//
//                        // handle error
//
//                    }
//
//                }
    }
    
    

    // MARK: - Helpers
    
    private func addChildVC() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.delegate = self
        menuVC.didMove(toParent: self)
        
        mainVC.delegate = self

        let navVC = UINavigationController(rootViewController: mainVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    
    
}

// MARK: - MainViewControllerDelegate
extension ContainerViewController: MainViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
                self?.navVC?.view.frame.origin.x = (self?.mainVC.view.bounds.size.width)! - 90
                let menuButton = self?.mainVC.headerView.subviews[0] as! UIButton
                menuButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
            
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
                self!.navVC?.view.frame.origin.x = 0
                let menuButton = self?.mainVC.headerView.subviews[0] as! UIButton
                menuButton.setImage(UIImage(systemName: "text.justify"), for: .normal)
            } completion: { done in
                if done {
                    self.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
}

// MARK: - MenuViewControllerDelegate
extension ContainerViewController: MenuViewControllerDelegate {
    func didSelected(menuItem: MenuViewController.MenuOptions) {
        toggleMenu { [weak self] in 
            switch menuItem {
            case .privacy:
                self?.setPrivacyView()
            case .library:
                print("library")
            case .service:
                print("service")
            case .appVersion:
                print("appVersion")
            }
        }
    }
    
    func setPrivacyView() {
        let privacyVC = privacyVC
        mainVC.navigationController?.pushViewController(privacyVC, animated: true)
    }
}
