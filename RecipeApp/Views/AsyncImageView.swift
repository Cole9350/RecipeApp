//
//  AsyncImageView.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var viewModel = AsyncImageViewModel()
    let url: URL

    var body: some View {
        Group {
            if let uiImage = viewModel.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .task {
                        await viewModel.loadImage(from: url)
                    }
            }
        }
    }
}
