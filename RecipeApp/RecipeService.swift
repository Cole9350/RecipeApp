//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import Foundation
import os

class RecipeService {
    func fetchRecipes() async throws -> [Recipe] {
        let logger = Logger()
        logger.info("Begin Fetching Images")
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(RecipeResponse.self, from: data)
        logger.info("End Fetching Images")
        return response.recipes
    }
}
