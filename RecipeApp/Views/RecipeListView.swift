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
            List {
                ForEach(viewModel.searchResults, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            if let url = URL(string: recipe.photoUrlLarge ?? recipe.photoUrlSmall ?? "") {
                                AsyncImageView(url: url)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.headline)
                                Text(recipe.cuisine)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.loadRecipes()
            }
            .refreshable {
                viewModel.clearImageCache()
                await viewModel.loadRecipes()
            }
            .searchable(text: $viewModel.searchText)
        }
    }
}


#Preview {
    RecipeListView()
}
