//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import UIKit
import os

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let logger = Logger()

    // Get image from cache or disk
    func getImage(for url: URL) -> UIImage? {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            logger.debug("Loaded image from cache \(url)")
            return cachedImage
        } else if let diskImage = loadFromDisk(url: url) {
            cache.setObject(diskImage, forKey: url.absoluteString as NSString)
            logger.debug("Loaded image from disk \(url)")
            return diskImage
        }
        return nil
    }

    // Save image to cache and disk
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
        saveToDisk(image: image, url: url)
    }

    // Load image from disk
    private func loadFromDisk(url: URL) -> UIImage? {
        let filePath = getDiskPath(for: url)
        return UIImage(contentsOfFile: filePath)
    }

    // Save image to disk
    private func saveToDisk(image: UIImage, url: URL) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filePath = getDiskPath(for: url)
        try? data.write(to: URL(fileURLWithPath: filePath))
    }
    
    // Get disk path for image using the full URL
    private func getDiskPath(for url: URL) -> String {
        let documentsPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        // Encode the URL to be filesystem-safe
        let encodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "default"
        
        return documentsPath.appendingPathComponent(encodedURL).path
    }
}

