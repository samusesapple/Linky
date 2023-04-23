//
//  AddViewViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import Foundation

struct FolderViewViewModel {
    
    var folder: Folder?
    var folderID: String?
    var folderIcon: String?
    var folderTitle: String?
    var tableViewLink: [Link]?
    var link: [Link]?
    
    init(folder: Folder) {
        folderID = folder.folderID
        folderIcon = folder.icon
        folderTitle = folder.title
        link = NetworkManager.shared.getLinks(with: folderID!)
    }
    
    init() { }

    
    mutating func updateLink(link: Link) {
        NetworkManager.shared.updateLinkData(to: link)
        self.link = NetworkManager.shared.getLinks(with: folderID!)
    }
    
    mutating func sortLinkCurrentLast(link: [Link]) {
        let linkArray = link.sorted(by: { $0.date.timeIntervalSinceReferenceDate < $1.date.timeIntervalSinceReferenceDate })
        self.link = linkArray
    }
    
    mutating func sortLinkCurrentFirst(link: [Link]) {
        let linkArray = link.sorted(by: { $0.date.timeIntervalSinceReferenceDate > $1.date.timeIntervalSinceReferenceDate })
        self.link = linkArray
    }
    
    mutating func sortLinkByKoreanLetter(link: [Link]) {
        let linkArray = link.sorted(by: { $0.memo ?? "" < $1.memo ?? "" })
        self.link = linkArray
    }
    
}
