//
//  MainViewViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import Foundation
import RxSwift

let sharedUserDefaults = UserDefaultsFileManager.shared

class MainViewViewModel {
    // folderArray 
    var folderArray: [Folder] = []
    
    private var linkSubject: PublishSubject<Link> = PublishSubject()
    private var disposeBag = DisposeBag()
    
    init() {
        self.folderArray = RealmNetworkManager.shared.getFolders()
    }
    
    func createNewFolder(folder: Folder) {
        RealmNetworkManager.shared.createFolder(newFolder: folder)
        self.folderArray.append(folder)
    }
    
    func deleteFolder(folderID: String) {
        RealmNetworkManager.shared.deleteFolder(with: folderID)
        self.folderArray = RealmNetworkManager.shared.getFolders()
    }
    
    func setSharedLinkData() {
        guard let sharedURL = sharedUserDefaults?.array(forKey: SharedUserDefaults.Keys.urlArray) else { return }
        
        for url in sharedURL {
            sendLinkToRealm(url: url as! String)
                .subscribe { link in
                    RealmNetworkManager.shared.createLink(newLink: link) {
                        sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.urlArray)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func sendLinkToRealm(url: String) -> Observable<Link> {

        return MetadataNetworkManager.shared.getMetadataTitleObservable(url)
            .observe(on: MainScheduler.asyncInstance)
            .filter({ _ in
                let sameLinks = RealmNetworkManager.shared.getLinks()
                    .filter { $0.urlString == url }
                return sameLinks.count == 0
            })
            .map { title in
                let newLink = Link()
                newLink.folderID = RealmNetworkManager.shared.getFolders()[0].folderID
                newLink.date = Date()
                newLink.urlString = url
                newLink.memo = title
                return newLink
            }
    }
    
}
