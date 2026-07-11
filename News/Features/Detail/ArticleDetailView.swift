//
//  ArticleDetailView.swift
//  News
//
//  Created by Parth Patel on 2026-07-05.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
	
	let article: Article
	@Environment(\.modelContext) private var context
	@State private var vm: ArticleDetailViewModel
	
	init(article: Article) {
		self.article = article
		self._vm = State(initialValue: ArticleDetailViewModel(article: article))
	}
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
					switch phase {
						case .success(let image):
							image
								.resizable()
								.aspectRatio(contentMode: .fill)
						default:
							RoundedRectangle(cornerRadius: 8)
								.fill(Color(.systemGray))
								.overlay {
									Image(systemName: "newspaper")
										.font(.system(size: 48))
										.foregroundStyle(.secondary)
								}
					}
				}
				.frame(maxWidth: .infinity)
			    .frame(height: 220)
			    .clipped()
				
				VStack(alignment: .leading, spacing: 12) {
					HStack {
						Text(article.source.name)
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.blue)
						Spacer()
						Text(article.publishedAt?.timeAgo() ?? "Unknown date")
							.font(.caption)
							.foregroundStyle(.secondary)
					}
					
					Text(article.title ?? "No Title")
						.font(.title3)
						.fontWeight(.bold)
					
					if let description = article.description {
						Text(description)
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					
					Divider()
					
					if let content = article.content {
						Text(content)
							.font(.body)
					}
					
					Button {
						vm.openInSafari()
					} label: {
						Text("Read Full Article")
							.font(.headline)
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color.blue)
							.foregroundStyle(.white)
							.clipShape(RoundedRectangle(cornerRadius: 12))
					}
				}
				.padding(.horizontal)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					vm.toggleBookmark(context: context)
				} label: {
					Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
						.foregroundStyle(vm.isBookmarked ? .blue : .primary)
				}
				.accessibilityLabel(vm.isBookmarked ? "Remove bookmark" : "Add bookmark")
			}
		}
		.task {
			vm.checkBookmarkStatus(context: context)
		}
	}
}

//#Preview {
//	ArticleDetailView()
//}
