//
//  LinkCellViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/20.
//

import Foundation

struct LinkCellViewModel {
    var linkURLString: String?
    var title: String?
    
    init(link: Link) {
        self.linkURLString = link.urlString
        self.title = link.memo
    }
    
    init() { }
    
    var linkURL: URL {
        return URL(string: linkURLString!)!
    }
}
