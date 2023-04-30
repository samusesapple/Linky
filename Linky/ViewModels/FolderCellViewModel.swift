//
//  FolderCellViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/30.
//

import Foundation

struct FolderCellViewModel {
    var isEmpty: Bool? = false
    
    let folder: Folder?
    let icon: String?
    let title: String?
    
    init(folder: Folder) {
        self.isEmpty = false
        self.folder = folder
        self.icon = folder.icon
        self.title = folder.title
    }
    
    init() {
        self.isEmpty = true
        self.icon = nil
        self.title = nil
        self.folder = nil
    }
    
    var linkCountString: String {
        let links = RealmNetworkManager.shared.getLinks(with: folder?.folderID ?? "ID없음")
        return "링크 \(links.count)개"
    }
    
}
