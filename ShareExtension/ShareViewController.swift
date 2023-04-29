//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Sam Sung on 2023/04/28.
//

import UIKit
import Social
import UniformTypeIdentifiers

let sharedUserDefaults = UserDefaultsFileManager.shared

class ShareViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlert()
    }
    
    
// MARK: - Helpers
    
    func presentAlert() {
        let alert = UIAlertController(title: "첫번째 폴더에 링크를 저장합니다.", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.saveURLAtUserDefaults()
            self?.hideExtensionWithCompletionHandler(completion: { _ in
                  self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
              })
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] action in
            self?.hideExtensionWithCompletionHandler(completion: { _ in
                  self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
              })
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
            }
        }
    
    
    func hideExtensionWithCompletionHandler(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.view.transform = CGAffineTransform(translationX: 0, y:self.navigationController!.view.frame.size.height)
        }, completion: completion)
    }
    
    
    func saveURLAtUserDefaults() {
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                // URL 타입 있는지 재차 확인 후, 해당 아이템 로딩하기
                if itemProvider.hasItemConformingToTypeIdentifier((UTType.url.identifier as CFString) as String) {
                    // 로딩되면 url을 String 타입으로 저장해야하므로 NSURL로 타입캐스팅
                    itemProvider.loadItem(forTypeIdentifier: (UTType.url.identifier as CFString) as String) { url, error in
                        guard error == nil else { return }
                        guard let url = url as? NSURL else { print("NSURL 전환 실패"); return }
                        guard let urlString = url.absoluteString else { return }
                        // 해당 url의 absoluteString을 UserDefaults의 배열에 Append
                        SharedUserDefaults.urlArray.append(urlString)
                    }
                }
            }
        }
    }
    
    
}
