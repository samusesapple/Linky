//
//  Data.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation
import RealmSwift

final class Folder: Object {
    @objc dynamic var icon: String?
    @objc dynamic var title: String?
    @objc dynamic var folderID = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "folderID"
    }
}


final class Link: Object {
    
    @objc dynamic var folderID: String?
    @objc dynamic var date: Date = Date()
    @objc dynamic var memo: String?
    @objc dynamic var urlString: String?
    
}
