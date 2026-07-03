//
//  NewsApp.swift
//  News
//
//  Created by Parth Patel on 2026-06-29.
//

import SwiftUI
import SwiftData

@main
struct NewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: CachedArticle.self)
    }
}
