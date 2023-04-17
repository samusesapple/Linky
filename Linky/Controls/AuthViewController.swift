//
//  AuthViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

class AuthViewController: UIViewController {

    override func loadView() {
        let authView = AuthView()
        self.view = authView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
