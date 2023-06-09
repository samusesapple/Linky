//
//  MainViewViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import Foundation

let sharedUserDefaults = UserDefaultsFileManager.shared

struct MainViewViewModel {
    var folderArray: [Folder] = []
    
    init() {
        self.folderArray = RealmNetworkManager.shared.getFolders()
    }
    
    mutating func createNewFolder(folder: Folder) {
        RealmNetworkManager.shared.createFolder(newFolder: folder)
        self.folderArray.append(folder)
    }
    
    mutating func deleteFolder(folderID: String) {
        RealmNetworkManager.shared.deleteFolder(with: folderID)
        self.folderArray = RealmNetworkManager.shared.getFolders()
    }
    
    func setSharedLinkData(completion: @escaping () -> Void) {
        guard let sharedURL = sharedUserDefaults?.array(forKey: SharedUserDefaults.Keys.urlArray) else { return }
        
        for url in sharedURL {
            sendLinkToRealm(url: url as! String) {
                completion()
            }
        }
    }
    
    private func sendLinkToRealm(url: String, completion: @escaping () -> Void) {
        let newLink = Link()
        newLink.folderID = RealmNetworkManager.shared.getFolders()[0].folderID
        newLink.date = Date()
        newLink.urlString = url
       MetadataNetworkManager.shared.getMetaDataTitle(urlString: url, completion: { string in
           newLink.memo = string
           
           // 중복되는 데이터가 있는지 확인 후, 있는 경우 저장 x
           if RealmNetworkManager.shared.getLinks().filter({ link in
               link.urlString == newLink.urlString
           }).count > 0 { print("이미 존재하는 url"); return } else {
               // 저장이 완료된 후, UserDefault에 저장된 배열값 초기화
               RealmNetworkManager.shared.createLink(newLink: newLink) {
                   sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.urlArray)
                   completion()
               }
    
           }
       })
        
    }
    
}
