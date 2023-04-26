//
//  ImageCacheManager.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/26.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
