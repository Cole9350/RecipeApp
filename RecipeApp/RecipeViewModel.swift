//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?
    
    private let service = RecipeService()
    
    func loadRecipes() async {
        do {
            let data = try await service.fetchRecipes()
            print("Fetching recipese")
            await MainActor.run {
                self.recipes = data
            }
        } catch {
            await MainActor.run {
                print("Got Error")
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
}
