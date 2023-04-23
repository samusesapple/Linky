//
//  AddLinkViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/20.
//

import Foundation

struct AddLinkViewModel {
    var folderArray: [Folder] = NetworkManager.shared.getFolders()
    var linkData: Link?
    var folderTitle: String?
    
    lazy var linkURL = linkData?.urlString
    lazy var linkMemo = linkData?.memo
    
    var folderNameArray: [String] {
        return folderArray.map { $0.title! }
    }
    
    func createLink(link: Link) {
        NetworkManager.shared.createLink(newLink: link)
    }
    
    
}


