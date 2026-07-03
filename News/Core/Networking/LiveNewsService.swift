//
//  LiveNewsService.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

final class LiveNewsService: NewsServiceProtocol {
	private let client: NetworkClient
	
	init(client: NetworkClient = .shared) {
		self.client = client
	}
	
	func fetchHeadlines(category: String, page: Int) async throws -> [Article] {
		let response = try await client.fetch(
			NewsResponse.self,
			from: .topHeadlines(category: category, page: page)
		)
		return response.articles
	}
	
	func searchArticles(query: String, page: Int) async throws -> [Article] {
		let response = try await client.fetch(
			NewsResponse.self,
			from: .search(query: query, page: page)
		)
		return response.articles
	}
	
	func fetchSources(category: String) async throws -> [ArticleSource] {
		return []
	}
}
