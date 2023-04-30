//
//  AddViewViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import Foundation
import Toast_Swift

struct FolderViewViewModel {
    
    var folderID: String?
    var folderIcon: String?
    var folderTitle: String?
    var links: [Link]?
    
    
    init(folder: Folder) {
        folderID = folder.folderID
        folderIcon = folder.icon
        folderTitle = folder.title
        links = RealmNetworkManager.shared.getLinks(with: folderID!)
    }
    
    init() { }
    
    mutating func remove(index: Int) {
        guard let link = links else { return }
        RealmNetworkManager.shared.deleteLink(with: link[index].date)
        links?.remove(at: index)
    }
    
    mutating func setLinks() {
        guard let folderID = folderID else { return }
        self.links = RealmNetworkManager.shared.getLinks(with: folderID)
        print("FolderVM - setLinks")
    }
    
    mutating func sortLinkCurrentLast(link: [Link]) {
        let linkArray = link.sorted(by: { $0.date.timeIntervalSinceReferenceDate < $1.date.timeIntervalSinceReferenceDate })
        self.links = linkArray
    }
    
    mutating func sortLinkCurrentFirst(link: [Link]) {
        let linkArray = link.sorted(by: { $0.date.timeIntervalSinceReferenceDate > $1.date.timeIntervalSinceReferenceDate })
        self.links = linkArray
    }
    
    mutating func sortLinkByKoreanLetter(link: [Link]) {
        let linkArray = link.sorted(by: { $0.memo ?? "" < $1.memo ?? "" })
        self.links = linkArray
    }
    
    // MARK: - Search Results
    mutating func getLinks(with text: String) {
        let memoResult = RealmNetworkManager.shared.getLinks().filter { link in
            guard let memo = link.memo?.lowercased() else { return false }
            return memo.contains(text)
        }
        
        let urlResult = RealmNetworkManager.shared.getLinks().filter { link in
            guard let url = link.urlString?.lowercased() else { return false }
            return url.contains(text)
        }
        
        self.links = memoResult + urlResult
    }
    
    mutating func getLinks(in folder: String, with text: String) {
        let memoResult = RealmNetworkManager.shared.getLinks().filter { link in
            guard let memo = link.memo?.lowercased() else { return false }
            return memo.contains(text)
        }
        
        let urlResult = RealmNetworkManager.shared.getLinks().filter { link in
            guard let url = link.urlString?.lowercased() else { return false }
            return url.contains(text)
        }
        let result = memoResult + urlResult
        
        self.links = result.filter { $0.folderID == folder }
    }
    
   
}
