//
//  SettingsView.swift
//  News
//
//  Created by Parth Patel on 2026-07-06.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
	
	@Environment(\.modelContext) private var context
	
	@AppStorage(UserDefaultsKeys.dailyRequestCount) private var dailyRequestCount: Int = 0
	@AppStorage(UserDefaultsKeys.defaultCategories) private var defaultCategory: String = "technology"
	@AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding: Bool = false
	
	@State private var cacheSize: Int = 0
	
	private let categories = ["technology", "business", "sports", "health", "entertainment", "science"]
	
    var body: some View {
		NavigationStack {
			List {
				Section("API Usage") {
					HStack {
						Label("Requests Today", systemImage: "network")
						Spacer()
						Text("\(dailyRequestCount) / 100")
							.foregroundStyle(dailyRequestCount > 80 ? .red : .secondary)
					}
					ProgressView(value: Double(dailyRequestCount) / 100)
						.tint(dailyRequestCount > 80 ? .red : .blue)
				}
				
				Section("Preferences") {
					Picker("Default Category", selection: $defaultCategory) {
						ForEach(categories, id: \.self) { category in
							Text(category.capitalized).tag(category)
						}
					}
				}
				
				Section("Data") {
					HStack {
						Label("Cached Articles", systemImage: "internaldrive")
						Spacer()
						Text("^[\(cacheSize) articles](inflect: true)")
							.foregroundStyle(.secondary)
					}
					Button(role: .destructive) {
						CacheManager.shared.clearAll(context: context)
						ImageCache.shared.clearAll()
						cacheSize = 0
					} label: {
						Label("Clear Cache", systemImage: "trash")
					}
				}
				
				Section("Onboarding") {
					Button {
						hasCompletedOnboarding = false
					} label: {
						Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
					}
				}
				
				Section("About") {
					HStack {
						Label("Data Provider", systemImage: "newspaper")
						Spacer()
						Text("NewsAPI.org")
							.foregroundStyle(.secondary)
					}
					
					HStack {
						Label("Version", systemImage: "info.circle")
						Spacer()
						Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
							.foregroundStyle(.secondary)
					}
				}
			}
			.navigationTitle("Settings")
			.onAppear {
				cacheSize = CacheManager.shared.cacheSize(context: context)
			}
		}
    }
}

#Preview {
    SettingsView()
}
