//
//  NewsServiceProtocol.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

protocol NewsServiceProtocol {
	func fetchHeadlines(category: String, page: Int) async throws -> [Article]
	func searchArticles(query: String, page: Int) async throws -> [Article]
	func fetchSources(category: String) async throws -> [ArticleSource]
}
