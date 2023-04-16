//
//  ViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = MainView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }

    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    
}


