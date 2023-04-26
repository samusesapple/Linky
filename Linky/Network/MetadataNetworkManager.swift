//
//  MetaDataNetworkManager.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/25.
//

import LinkPresentation
import Foundation

struct MetadataNetworkManager {

    static var shared = MetadataNetworkManager()

    private var provider = LPMetadataProvider()
//    private var linkView = LPLinkView()
    
    private init() {}
    
    // Re-create the provider
// MARK: - Fetch Title
    func getMetaDataTitle(urlString: String, completion: @escaping (String) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        let provider = LPMetadataProvider()
        
        // Start fetching metadata
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil
            else { return }
            // Use the metadata
            print(metadata.title ?? "No Title")
            guard let title = metadata.title else { return }
            DispatchQueue.main.async {
              completion(title)
//                self.linkView.metadata = metadata
            }
        }
    }
    

// MARK: - Fetch Image
    mutating func getMetaDataImage(urlString: String, completion: @escaping (LPLinkView) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        let provider = LPMetadataProvider()
        let linkView = LPLinkView(url: url)
        // Start fetching metadata
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil
            else { return }
            // Use the metadata
            print(metadata)
            DispatchQueue.main.async {
                linkView.metadata = metadata
              completion(linkView)
            }
        }
    }
    
    
}
