//
//  MetaDataNetworkManager.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/25.
//

import Foundation
import LinkPresentation

struct MetadataNetworkManager {

    static var shared = MetadataNetworkManager()
    private var provider = LPMetadataProvider()
    
    private init() {}

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
            }
        }
    }
    
// MARK: - Fetch Rich Data for share sheet

    func getRichMetadata(urlString: String, completion: @escaping (LPLinkView) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        let provider = LPMetadataProvider()
        let linkView = LPLinkView(url: url)
        // Start fetching metadata
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil
            else { return }
            // Use the metadata
            DispatchQueue.main.async {
                linkView.metadata = metadata
              completion(linkView)
            }
        }
    }
    
// MARK: - Fetch Images for linkCell

    func getMetaDataOnlyImage(urlString: String, completion: @escaping (UIImage) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        let cacheKey = NSString(string: urlString)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        let provider = LPMetadataProvider()
        // Start fetching metadata
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil
            else { return }
            // Use the metadata
            let imageData = metadata.imageProvider?.loadObject(ofClass: UIImage.self) { image, error in
                let image = image as! UIImage
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async {
                    completion(image)
                    return
                }
            }
            
            guard let imageData = imageData else {
                let iconData = metadata.iconProvider?.loadObject(ofClass: UIImage.self) { icon, error in
                    let icon = icon as! UIImage?
                    guard let icon = icon else { return }
                    ImageCacheManager.shared.setObject(icon, forKey: cacheKey)
                    DispatchQueue.main.async {
                        completion(icon)
                    }
                }
            return }
        }
    }
 

}
