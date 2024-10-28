//
//  YouTubePlayerView.swift
//  RecipeApp
//
//  Created by Shawn Cole on 10/28/24.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


#Preview {
    YouTubePlayerView(url: URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!)
}
