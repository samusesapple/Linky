//
//  MainViewViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import Foundation

struct MainViewViewModel {
    var folderArray: [Folder] = []
    
    init() {
        self.folderArray = NetworkManager.shared.getFolders()
    }
    
    mutating func createNewFolder(folder: Folder) {
        NetworkManager.shared.createFolder(newFolder: folder)
        self.folderArray.append(folder)
    }
    
    mutating func deleteFolder(folderID: String) {
        NetworkManager.shared.deleteFolder(with: folderID)
        self.folderArray = NetworkManager.shared.getFolders()
    }
}

struct FolderCellViewModel {
    var isEmpty: Bool = false
    
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
        self.icon = ""
        self.title = ""
        self.folder = nil
    }
    
    var linkCountString: String {
        let links = NetworkManager.shared.getLinks(with: folder?.folderID ?? "ID없음")
        return "링크 \(links.count)개"
    }
    
}
