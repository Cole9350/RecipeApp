//
//  Recipe.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import Foundation

struct Recipe: Decodable, Identifiable {
    let uuid: String
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    var id: String { uuid }
}

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}
