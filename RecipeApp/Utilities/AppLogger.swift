//
//  AppLogger.swift
//  RecipeApp
//
//  Created by Shawn Cole on 11/3/24.
//

import os

struct AppLogger {
    static let shared = Logger(subsystem: "com.scole.RecipeApp", category: "General")
}
