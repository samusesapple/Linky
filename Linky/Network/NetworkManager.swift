//
//  File.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation
import RealmSwift

final class NetworkManager {
    
    // Realm 데이터베이스 객체 생성
        let realm = try! Realm()
        
    // 싱글턴 객체로, RealmManager 클래스의 인스턴스를 반환한다.
        static let shared = NetworkManager()
    
    // Folder 객체 배열
        var folderArray = [Folder]()
    // linkData 객체의 배열
        var linkArray = [LinkData]()
        
        // MARK: - Create
        
    func createFolder(folderData: Folder) {
        // 저장할 데이터 객체 생성
        let newData = Folder()
        newData.folderID = UUID().uuidString
        newData.icon = folderData.icon
        newData.title = folderData.title
        
        // Realm 데이터베이스에 데이터 저장
        try! realm.write {
            realm.add(newData)
        }
    }
        
        func createLink(linkData: LinkData) {
            // 저장할 데이터 객체 생성
            let newData = LinkData()
            newData.linkID = UUID().uuidString
            newData.folder = linkData.folder
            newData.date = linkData.date
            newData.urlString = linkData.urlString
            newData.urlImage = linkData.urlImage
            
            // Realm 데이터베이스에 데이터 저장
            try! realm.write {
                realm.add(newData)
            }
        }
        
        func getLinkData(withId id: String) -> LinkData? {
            // 기존 데이터 가져오기
            let existingData = realm.objects(LinkData.self).filter { $0.linkID == id }.first
            return existingData
        }
        
    func getFolderData(withId id: String) -> Folder? {
        // 기존 데이터 가져오기
        let existingData = realm.objects(Folder.self).filter { $0.folderID == id }.first
        return existingData
    }
    
        
        // MARK: - Read
        
        func fetchAllFolders() -> Results<Folder> {
            let results = realm.objects(Folder.self).sorted(byKeyPath: "title", ascending: false)
            return results
        }
    
    func fetchAllLinks() -> Results<LinkData> {
        let results = realm.objects(LinkData.self).sorted(byKeyPath: "date", ascending: false)
        return results
    }
        
        func fetch(byFolder folder: Folder) -> LinkData? {
            let predicate = NSPredicate(format: folder.folderID)
            let results = realm.objects(LinkData.self).filter(predicate)
            return results.first
        }
        
        // MARK: - Update

    func updateFolderData(folderData: Folder) {
        guard let existingData = getFolderData(withId: folderData.folderID) else { return }
        do {
            try realm.write {
                existingData.icon = folderData.icon
                existingData.title = folderData.title
            }
        } catch {
            print("Folder update failed")
        }
    }
    
        func updateLinkData(linkData: LinkData) {
            // 기존 데이터 업데이트
            guard let existingData = getLinkData(withId: linkData.linkID) else {
                return
            }
            do {
                try realm.write {
                    existingData.date = linkData.date
                    existingData.urlString = linkData.urlString
                    existingData.title = linkData.title
                    existingData.folder = linkData.folder
                    existingData.urlImage = linkData.urlImage
                }
            } catch {
                print("Link update failed")
            }

        }
        
        // MARK: - Delete
        
    func deleteFolder(folderData: Folder) {
        do {
            try realm.write {
                realm.delete(folderData)
            }
        } catch {
            print("Error deleting FOLDER: \(error)")
            
        }
    }
    
        func deleteLink(linkData: LinkData) {
            do {
                try realm.write {
                    realm.delete(linkData)
                }
            } catch {
                print("Error deleting LINK: \(error)")
                
            }
        }
}
