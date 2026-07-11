//
//  BookmarksView.swift
//  News
//
//  Created by Parth Patel on 2026-07-06.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
	
	@Environment(\.modelContext) private var context
	@Query(sort: \BookmarkedArticle.bookmarkedAt, order: .reverse) private var bookmarks: [BookmarkedArticle]
	@State private var vm = BookmarksViewModel()
	
    var body: some View {
		NavigationStack {
			Group {
				if bookmarks.isEmpty {
					emptyState
				} else {
					bookmarksList
				}
			}
			.navigationTitle("Bookmarks")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					if !bookmarks.isEmpty {
						Button("Clear All", role: .destructive) {
							vm.deleteAll(context: context)
						}
					}
				}
			}
		}
    }
	
	private var bookmarksList: some View {
		List {
			ForEach(bookmarks) { bookmark in
				NavigationLink(value: bookmark.toArticle()) {
					ArticleCardView(article: bookmark.toArticle())
				}
				.listRowSeparator(.hidden)
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Button(role: .destructive) {
						vm.delete(bookmark, context: context)
					} label: {
						Label("Delete", systemImage: "trash")
					}
					.accessibilityLabel("Delete bookmark")
				}
			}
		}
		.listStyle(.plain)
		.navigationDestination(for: Article.self) { article in
			ArticleDetailView(article: article)
		}
	}
	
	private var emptyState: some View {
		EmptyStateView(
			title: "No Bookmarks Yet",
			message: "Tap the bookmark icon on any article to save it for later.",
			systemImage: "bookmark"
		)
	}
}

#Preview {
    BookmarksView()
}
