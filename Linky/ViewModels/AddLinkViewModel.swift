//
//  AddLinkViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/20.
//

import Foundation

struct AddLinkViewModel {
    var folderArray: [Folder] = RealmNetworkManager.shared.getFolders()
    var linkData: Link?
    var folderTitle: String?
    
    lazy var linkURL = linkData?.urlString
    lazy var linkMemo = linkData?.memo
    
    var folderNameArray: [String] {
        return folderArray.map { $0.title! }
    }
    
    func createLink(link: Link) {
        guard let url = link.urlString else { return }
        guard let memo = link.memo else { return }
        if memo.count > 0 {
            // 제목 정하지 않으면, 자동으로 링크에 대한 제목 만들기
            RealmNetworkManager.shared.createLink(newLink: link)
        } else {
            MetadataNetworkManager.shared.getMetaDataTitle(urlString: url) { data in
                link.memo = data
                RealmNetworkManager.shared.createLink(newLink: link)
            }
        }
    }
    
    func updateLink(link: Link) {
        RealmNetworkManager.shared.updateLinkData(to: link)
    }
    
    func getFolderTitle(with link: Link) -> String {
        let folder = RealmNetworkManager.shared.getFolders().filter { $0.folderID == link.folderID }.first
        return folder?.title ?? ""
    }
}


