//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Shawn Cole on 10/28/24.
//

import Testing
import Foundation
@testable import RecipeApp


struct RecipeServiceTests {

    @Test func testFetchRecipesSuccess() async throws {
        let mockSession = MockURLSession()
        let jsonData = """
        {
            "recipes": [{
                "uuid": "1234",
                "cuisine": "Italian",
                "name": "Mock Pasta",
                "photo_url_large": "https://example.com/large.jpg",
                "photo_url_small": "https://example.com/small.jpg"
            }]
        }
        """.data(using: .utf8)!

        mockSession.data = jsonData
        let service = RecipeService(session: mockSession)

        let recipes = try await service.fetchRecipes()
        #expect(recipes.count  == 1)
        #expect(recipes.first?.name == "Mock Pasta")
    }
    
    @Test func testFetchRecipesFailure() async throws {
        let mockSession = MockURLSession()
        mockSession.error = URLError(.badServerResponse)
        
        let service = RecipeService(session: mockSession)
        
        await #expect(throws: (any Error).self) {
            _ = try await service.fetchRecipes()
        }
    }
}
