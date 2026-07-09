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
	
	@State private var networkMonitor = NetworkMonitor.shared
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(networkMonitor)
				.modelContainer(for: [CachedArticle.self, BookmarkedArticle.self])
        }
    }
}
