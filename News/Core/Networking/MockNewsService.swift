//
//  MockNewsService.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

final class MockNewsService: NewsServiceProtocol {
	
	static let sampleArticles: [Article] = [
		Article(
			title: "Apple announces new iPhone features",
			description: "Apple has unveiled exciting new features coming to iPhone this fall.",
			url: "https://example.com/article1",
			urlToImage: "https://picsum.photos/800/400",
			publishedAt: "2025-01-01T10:00:00Z",
			content: "Full article content here...",
			source: ArticleSource(id: "apple", name: "Apple Newsroom")
		),
		Article(
			title: "Swift 6 brings major concurrency improvements",
			description: "The latest version of Swift makes concurrent programming safer and easier.",
			url: "https://example.com/article2",
			urlToImage: "https://picsum.photos/800/401",
			publishedAt: "2025-01-02T09:00:00Z",
			content: "Full article content here...",
			source: ArticleSource(id: "swift", name: "Swift Blog")
		),
		Article(
			title: "iOS development job market grows in 2025",
			description: "Demand for iOS developers continues to rise as mobile usage increases.",
			url: "https://example.com/article3",
			urlToImage: "https://picsum.photos/800/402",
			publishedAt: "2025-01-03T08:00:00Z",
			content: "Full article content here...",
			source: ArticleSource(id: "tech", name: "TechCrunch")
		)
	]
	
	func fetchHeadlines(category: String, page: Int) async throws -> [Article] {
		try await Task.sleep(nanoseconds: 500_000_000)
		return Self.sampleArticles
	}
	
	func searchArticles(query: String, page: Int) async throws -> [Article] {
		try await Task.sleep(nanoseconds: 500_000_000)
		return Self.sampleArticles.filter {
			$0.title.localizedCaseInsensitiveContains(query)
		}
	}
	
	func fetchSources(category: String) async throws -> [ArticleSource] {
		try await Task.sleep(nanoseconds: 300_000_000)
		return [
			ArticleSource(id: "bbc-news", name: "BBC News"),
		   ArticleSource(id: "cnn", name: "CNN"),
		   ArticleSource(id: "the-verge", name: "The Verge")
		]
	}
}
