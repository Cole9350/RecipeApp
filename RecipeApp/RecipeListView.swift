//
//  RecipeListView.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.recipes, id: \Recipe.id) { recipe in
                HStack {
                    if let url = URL(string: recipe.photoUrlSmall ?? "") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                    }
                    
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
}

#Preview {
    RecipeListView()
}
