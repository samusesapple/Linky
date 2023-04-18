//
//  AddViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class AddViewController: UIViewController {
    
    override func loadView() {
        let addView = AddView()
        addView.delegate = self
        self.view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

extension AddViewController: AddViewDelegate {
    func selectFolder() {
        print(#function)

    }
    
    func handleBackButton() {
        self.dismiss(animated: true)
    }
    
    func handleSaveButton() {
        self.dismiss(animated: true)
    }
    
    
}
