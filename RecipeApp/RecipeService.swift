//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import Foundation

class RecipeService {
    func fetchRecipes() async throws -> [Recipe] {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response =  try decoder.decode(RecipeResponse.self, from: data)
        return response.recipes
    }
}
