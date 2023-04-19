//
//  Data.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation
import RealmSwift

final class Folder: Object {
    @objc dynamic var folderID = ""
    
    @objc dynamic var icon: String = ""
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "folderID"
    }
}

final class LinkData: Object {
    @objc dynamic var linkID = ""
    
    @objc dynamic var folder: Folder?
    @objc dynamic var date: Date = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var urlString: String = ""
    @objc dynamic var urlImage: String = ""
    
    override static func primaryKey() -> String? {
        return "linkID"
    }
    
}
