//
//  ContainerViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    private enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    private let mainVC = MainViewController()
    private let menuVC = MenuViewController()
    private var navVC: UINavigationController?
    private lazy var privacyVC = PrivacyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChildVC()
    }
    
    
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

extension ContainerViewController: MainViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.mainVC.view.anchorPoint.x + 290
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
            
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
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
