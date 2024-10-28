//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI
import WebKit
struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center) {
                    HStack {
                        Text(recipe.name)
                            .font(.largeTitle)
                        Spacer()
                        Text(recipe.cuisine)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                    }
                    .padding()
                    
                    if let sourceUrl = recipe.sourceUrl, let url = URL(string: sourceUrl) {
                        Link("View Full Recipe", destination: url)
                            .font(.headline)
                    }

                    if let urlString = recipe.youtubeUrl, let url = URL(string: urlString) {
                        YouTubePlayerView(url: url)
                            .frame(height: geometry.size.height * 0.7)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    RecipeDetailView(recipe: .mock)
}
