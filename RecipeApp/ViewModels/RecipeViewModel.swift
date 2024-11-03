//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI
import Combine
import os

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?

    private let service = RecipeService()
    private let logger = AppLogger.shared

    func loadRecipes() async {
        do {
            let data = try await service.fetchRecipes()
            await MainActor.run {
                self.recipes = data
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                logger.error("Error loading recipes: \(self.errorMessage ?? "")")
            }
        }
    }

    // Fetch Image and Cache
    func fetchImage(for url: URL) async -> UIImage? {
        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.getImage(for: url) {
            return cachedImage
        }
        
        // Download and cache the image if not cached
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.global(qos: .background).async {
                    ImageCache.shared.saveImage(image, for: url)
                }
                return image
            }
        } catch {
            self.errorMessage = error.localizedDescription
            logger.error("Failed to fetch image: \(self.errorMessage ?? "")")
        }
        return nil
    }
    
    func clearImageCache() {
        ImageCache.shared.clearCache()
    }
}
