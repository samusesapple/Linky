//
//  File.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation
import RealmSwift
import RxSwift

final class RealmNetworkManager {
    private let realm = try! Realm()
    
    static let shared = RealmNetworkManager()
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
    
    func createLink(newLink: Link, completion: @escaping () -> Void) {
        do {
            try realm.write {
                realm.add(newLink) }
        } catch { print("Create Link Failed") }
        completion()
    }
    
    func createLinkObservable(newLink: Link) -> Observable<Link> {
        return Observable.create { [weak self] emitter in
            do {
                try self?.realm.write {
                    self?.realm.add(newLink)
                    emitter.onNext(newLink)
                }
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }
    
    // MARK: - [READ]
    
    func getFolders() -> [Folder] {
        folderArray = realm.objects(Folder.self).map { $0 as Folder }
        return folderArray
    }
    
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
        print("폴더 삭제 완료")
    }
    
    func deleteLink(with date: Date) {
        let file = realm.objects(Link.self).filter { $0.date == date }
        try! realm.write{
            realm.delete(file)
        }
        print("링크 삭제 완료")
    }
    
}
