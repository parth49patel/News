//
//  HeadlinesView.swift
//  News
//
//  Created by Parth Patel on 2026-07-05.
//

import SwiftUI
import SwiftData

struct HeadlinesView: View {
	
	@Environment(\.modelContext) private var context
	@Environment(NetworkMonitor.self) private var monitor
	
	@State private var vm = HeadlinesViewModel()
	
    var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				if !monitor.isConnected {
					offlineBanner
				}
				
				categoryTabs
				
				contentView
				
			}
			.navigationTitle("Top Headlines")
			.task {
				await vm.loadHeadlines(context: context)
			}
			.onChange(of: monitor.isConnected) { _, isConnected in
				if isConnected {
					Task { await vm.loadHeadlines(context: context) }
				}
			}
		}
    }
	
	@ViewBuilder
	private var contentView: some View {
		switch vm.state {
			case .loading, .idle:
				LoadingState()
			case .success(let articles):
				articlesList(articles)
			case .failure(let error):
				ErrorView(message: error.localizedDescription ?? "Something went wrong") {
						Task { await vm.loadHeadlines(context: context) }
					}
			case .empty:
				EmptyStateView(
					title: "No Headlines",
					message: "No articles found for this category",
					systemImage: "newspaper")
		}
	}
	
	private func articlesList(_ articles: [Article]) -> some View {
		List {
			ForEach(articles) { article in
				NavigationLink(value: article) {
					ArticleCardView(article: article)
				}
				.listRowSeparator(.hidden)
				.onAppear {
					if article == articles.last {
						Task { await vm.loadMore(context: context) }
					}
				}
			}
		}
		.listStyle(.plain)
		.refreshable {
			await vm.refresh(context: context)
		}
		.navigationDestination(for: Article.self) { article in
			ArticleDetailView(article: article)
		}
	}
	
	private var categoryTabs: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(vm.categories, id: \.self) { category in
					Button {
						Task { await vm.selectCategory(category, context: context) }
					} label: {
						Text(category.capitalized)
							.font(.subheadline)
							.fontWeight(.medium)
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
							.background(
								vm.selectedCategory == category ? Color.blue : Color(.systemGray6)
							)
							.foregroundStyle(
								vm.selectedCategory == category ? .white : .primary
							)
							.clipShape(Capsule())
					}
				}
			}
			.padding(.horizontal)
			.padding(.vertical, 8)
		}
	}
	
	private var offlineBanner: some View {
		HStack {
			Image(systemName: "wifi.slash")
			Text("Your're offline - showing cached content")
				.font(.caption)
		}
		.foregroundStyle(.white)
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity)
		.background(Color.orange)
	}
	
}

#Preview {
    HeadlinesView()
		.environment(NetworkMonitor.shared)
}
