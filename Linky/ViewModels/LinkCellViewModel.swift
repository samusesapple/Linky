//
//  LinkCellViewModel.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/20.
//

import Foundation
import LinkPresentation

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
    
    func setMetadataImage(urlString: String, sender: UIButton) {
        MetadataNetworkManager.shared.getMetaDataOnlyImage(urlString: urlString) { image in
            sender.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
}
