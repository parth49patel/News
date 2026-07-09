//
//  BookmarkedArticle.swift
//  News
//
//  Created by Parth Patel on 2026-07-05.
//

import Foundation
import SwiftData

@Model
class BookmarkedArticle {
	var title: String?
	var arcticleDescription: String?
	var url: String?
	var urlToImage: String?
	var publishedAt: String?
	var content: String?
	var sourceName: String
	var sourceId: String?
	var bookmarkedAt: Date
	
	init(article: Article) {
		self.title = article.title
		self.arcticleDescription = article.description
		self.url = article.url
		self.urlToImage = article.urlToImage
		self.publishedAt = article.publishedAt
		self.content = article.content
		self.sourceName = article.source.name
		self.sourceId = article.source.id
		self.bookmarkedAt = Date()
	}
	
	func toArticle() -> Article {
		Article(
			title: title,
			description: arcticleDescription ?? "",
			url: url,
			urlToImage: urlToImage ?? "",
			publishedAt: publishedAt,
			content: content,
			source: ArticleSource(id: sourceId, name: sourceName)
		)
	}
}
