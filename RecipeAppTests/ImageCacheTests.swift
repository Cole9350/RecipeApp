//
//  ImageCacheTests.swift
//  RecipeAppTests
//
//  Created by Shawn Cole on 11/3/24.
//

import Testing
import UIKit
@testable import RecipeApp


struct ImageCacheTests {
    @Test func testClearCache() {
        let mockURL = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "photo")!
        ImageCache.shared.saveImage(image, for: mockURL)
        #expect(ImageCache.shared.getImage(for: mockURL) != nil)
        ImageCache.shared.clearCache()
        #expect(ImageCache.shared.getImage(for: mockURL) == nil)
    }
}
