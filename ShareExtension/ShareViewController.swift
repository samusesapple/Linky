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

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        placeholder = "(선택) 링크의 제목을 지어주세요. \n 해당 링크는 맨 첫번째 폴더에 저장됩니다."
        return true
    }
    
    override func didSelectPost() {
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
                        print(SharedUserDefaults.urlArray)

                    }
                }
            }
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    //                        sharedUserDefaults?.set(self?.contentText, forKey: SharedUserDefaults.Keys.memo)
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
