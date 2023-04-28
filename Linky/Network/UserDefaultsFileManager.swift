//
//  File.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/28.
//

import Foundation

class UserDefaultsFileManager {
    
    static let shared = UserDefaults(suiteName: SharedUserDefaults.suiteName)
    
    private init() {}

    
}
