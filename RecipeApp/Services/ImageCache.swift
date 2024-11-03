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
    private let logger = AppLogger.shared

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
    
    // Clears both the in-memory cache and the disk cache.
    func clearCache() {
        clearMemoryCache()
        clearDiskCache()
    }

    // Clears the in-memory NSCache.
    private func clearMemoryCache() {
        cache.removeAllObjects()
        logger.debug("In-memory image cache cleared.")
    }

    // Clears the disk cache by removing all cached image files.
    private func clearDiskCache() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let cachedFiles = try fileManager.contentsOfDirectory(atPath: cachesDirectory.path)
            for file in cachedFiles {
                let filePath = cachesDirectory.appendingPathComponent(file).path
                try fileManager.removeItem(atPath: filePath)
                logger.debug("Removed cached image file at path: \(filePath)")
            }
            logger.debug("Disk image cache cleared.")
        } catch {
            logger.error("Error clearing disk cache: \(error.localizedDescription)")
        }
    }
}

