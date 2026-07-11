//
//  SearchView.swift
//  News
//
//  Created by Parth Patel on 2026-07-06.
//

import SwiftUI

struct SearchView: View {
	
	@Environment(NetworkMonitor.self) private var monitor
	@State private var vm = SearchViewModel()
    
	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				if !monitor.isConnected {
					offlineBanner
				}
				contentView
			}
			.navigationTitle("Search")
			.searchable(
				text: Binding(
					get: { vm.searchText },
					set: { vm.search(query: $0) }
				),
				prompt: monitor.isConnected ? "Search for news..." : "No internet connection"
			)
			.disabled(!monitor.isConnected)
			.accessibilityHint(monitor.isConnected ? "" : "Search is unavailable while offline.")
		}
    }
	
	
	private var offlineBanner: some View {
		HStack {
			Image(systemName: "wifi.slash")
			Text("You're offline - search unavailable")
				.font(.caption)
		}
		.foregroundStyle(.white)
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity)
		.background(Color.orange)
	}
	
	@ViewBuilder
	private var contentView: some View {
		switch vm.state {
			case .loading:
				LoadingState(message: "Searching...")
			case .success(let articles):
				articlesList(articles)
			case .failure(let error):
				ErrorView(message: error.localizedDescription) {
					vm.search(query: vm.searchText)
				}
			case .empty:
				EmptyStateView(
					title: "No Results",
					message: "No articles found for \"\(vm.searchText)\"",
					systemImage: "magnifyingglass")
			case .idle:
				idleView
		}
	}
	
	private var idleView: some View {
		VStack(spacing: 16) {
			if monitor.isConnected {
				Image(systemName: "newspaper")
					.font(.system(size: 48))
					.foregroundStyle(.secondary)
				Text("Search for any topic")
					.font(.headline)
				Text("Climate, technology, sports, polictics...")
					.font(.subheadline)
					.foregroundStyle(.secondary)
			} else {
				Image(systemName: "wifi.slash")
					.font(.system(size: 48))
					.foregroundStyle(.secondary)
				Text("You're Offline")
					.font(.headline)
				Text("Connect to the internet to search for news")
					.font(.subheadline)
				    .foregroundStyle(.secondary)
				    .multilineTextAlignment(.center)
				    .padding(.horizontal, 32)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	private func articlesList(_ articles: [Article]) -> some View {
		List {
			ForEach(articles) { article in
				NavigationLink(value: article) {
					ArticleCardView(article: article)
				}
				.listRowSeparator(.hidden)
			}
		}
		.listStyle(.plain)
		.navigationDestination(for: Article.self) { article in
			ArticleDetailView(article: article)
		}
	}
}

#Preview {
    SearchView()
		.environment(NetworkMonitor.shared)
	
}
