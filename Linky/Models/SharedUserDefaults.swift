//
//  SharedUserDefaults.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/28.
//

import Foundation

struct SharedUserDefaults {
    static let suiteName = "group.com.samSung.Linky"
    
    struct Keys {
        static let urlArray: String = "urlArray"
        static let memo: String = "memo"
    }
    
    static var urlArray: [String] {
        get {
            return UserDefaultsFileManager.shared?.array(forKey: "urlArray") as? [String] ?? []
        }
        set {
            UserDefaultsFileManager.shared?.set(newValue, forKey: "urlArray")
        }
    }
    
    
}

