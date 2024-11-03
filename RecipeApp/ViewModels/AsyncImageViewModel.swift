//
//  AsyncImageViewModel.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI
import Combine

class AsyncImageViewModel: ObservableObject {
    @Published var uiImage: UIImage?
    let logger = AppLogger.shared
    
    func loadImage(from url: URL) async {
        // Check the cache first
        if let cachedImage = ImageCache.shared.getImage(for: url) {
            await MainActor.run {
                self.uiImage = cachedImage
            }
            return
        }
        
        // Fetch from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                // Save to cache and update UI
                ImageCache.shared.saveImage(image, for: url)
                await MainActor.run {
                    self.uiImage = image
                }
            }
        } catch {
            logger.error("Failed to load image from \(url): \(error)")
        }
    }
}
