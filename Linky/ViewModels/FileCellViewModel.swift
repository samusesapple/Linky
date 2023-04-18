//
//  FileCellViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/18.
//

import Foundation

struct FileCellViewModel {
    var isFocused: Bool = false
    var isEmpty: Bool = false
    
    private let labelText: String
    private let title: String
    private let linkCount: Int
    
    init(isFocused: Bool, isEmpty: Bool, labelText: String, title: String, linkCount: Int) {
        self.isFocused = isFocused
        self.isEmpty = isEmpty
        self.labelText = labelText
        self.title = title
        self.linkCount = linkCount
    }

    
}
