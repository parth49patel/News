//
//  ContentView.swift
//  News
//
//  Created by Parth Patel on 2026-06-29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			Tab("Headlines", systemImage: "newspaper") {
				HeadlinesView()
			}
			
			Tab("Search", systemImage: "magnifyingglass") {
				SearchView()
			}
			
			Tab("Bookmarks", systemImage: "bookmark") {
				BookmarksView()
			}
			
			Tab("Settings", systemImage: "gearshape") {
				SettingsView()
			}
		}
    }
}

#Preview {
    ContentView()
		.environment(NetworkMonitor.shared)
}
