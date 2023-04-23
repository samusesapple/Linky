//
//  File.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation
import RealmSwift

final class NetworkManager {
    private let realm = try! Realm()
    
    static let shared = NetworkManager()
    private init() {}
    
    private var folderArray: [Folder] = []
    private var linkArray: [Link] = []
    private var certainLinkArray: [Link] = []
    
// MARK: - [CREATE]
    
    func createFolder(newFolder: Folder) {
        do {
            try realm.write {
                realm.add(newFolder) }
        } catch { print("Create Folder Failed") }
    }
    
    func createLink(newLink: Link) {
        do {
            try realm.write {
                realm.add(newLink) }
        } catch { print("Create Link Failed") }
    }
    
// MARK: - [READ]
    
    func getFolders() -> [Folder] {
        folderArray = realm.objects(Folder.self).map { $0 as Folder }
        return folderArray
    }
    
//    func getFolderTitle(with folderID: String) -> String {
//        folderArray = realm.objects(Folder.self).map { $0 as Folder }
//        let folder = 
//        return folder?.title ?? "!!"
//    }
    
    func getLinks() -> [Link] {
        linkArray = realm.objects(Link.self).map { $0 as Link }
        return linkArray
    }
    
    func getLinks(with folderID: String) -> [Link] {
        certainLinkArray = realm.objects(Link.self).map { $0 as Link }
        let array = certainLinkArray.filter { $0.folderID == folderID }
        return array
    }
    
// MARK: - [UPDATAE]
    
    func updateLinkData(to newLink: Link) {
        let previousData = realm.objects(Link.self).filter{ $0.urlString == newLink.urlString }.first
        
        try! realm.write {
            previousData?.folderID = newLink.folderID
            previousData?.memo = newLink.memo
        }
        
    }
    
// MARK: - [DELETE]
    
    func deleteFolder(with folderID: String) {
        let folder = realm.objects(Folder.self).filter { $0.folderID == folderID }
        let file = realm.objects(Link.self).filter { $0.folderID == folderID }
        try! realm.write{
            realm.delete(folder)
            realm.delete(file)
        }
        print("\(folderID) 삭제 완료")
    }
    
}
