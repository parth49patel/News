//
//  ArticleCardView.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import SwiftUI

struct ArticleCardView: View {
	var article: Article
	
	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
				switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					case .failure:
						placeHolderImage
					case .empty:
						placeHolderImage
							.overlay(ProgressView())
					@unknown default:
						placeHolderImage
				}
			}
			.frame(width: 90, height: 90)
			.clipShape(RoundedRectangle(cornerRadius: 8))
		}
		
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text(article.source.name)
					.font(.caption)
					.fontWeight(.semibold)
					.foregroundStyle(.blue)
				Spacer()
				Text(article.publishedAt?.timeAgo() ?? "Unknown date")
					.font(.caption)
					.foregroundStyle(.secondary)
					.lineLimit(2)
			}
				Text(article.title ?? "No Title")
					.font(.subheadline)
					.fontWeight(.semibold)
					.lineLimit(2)
				
				if let description = article.description {
					Text(description)
						.font(.caption)
						.foregroundStyle(.secondary)
						.lineLimit(2)
				}
		}
		.padding(.vertical, 4)
	}
	
	private var placeHolderImage: some View {
		Rectangle()
			.fill(Color(.systemGray5))
			.overlay {
				Image(systemName: "newspaper")
					.foregroundStyle(.secondary)
			}
	}
}
