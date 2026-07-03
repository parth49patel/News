//
//  CacheManager.swift
//  News
//
//  Created by Parth Patel on 2026-07-02.
//

import Foundation
import SwiftData

final class CacheManager {
	static let shared = CacheManager()
	private init() {}
	
	private let cachedExpiryMinutes: Double = 30
	
	func save(articles: [Article], category: String, page: Int, context: ModelContext) {
		let existing = fetch(category: category, page: page, context: context, ignoreExpiry: true)
		if !existing.isEmpty {
			deleteExisting(category: category, page: page, context: context)
		}
		
		for article in articles {
			let cached = CachedArticle(article: article, category: category, page: page)
			context.insert(cached)
		}
		
		try? context.save()
	}
	
	func fetch(category: String, page: Int, context: ModelContext, ignoreExpiry: Bool = false) -> [Article] {
		let descriptor = FetchDescriptor<CachedArticle>(
			predicate: #Predicate { $0.category == category && $0.page == page},
			sortBy: [SortDescriptor(\.cachedAt, order: .reverse)]
		)
		
		guard let results = try? context.fetch(descriptor), !results.isEmpty else { return [] }
		
		if !ignoreExpiry {
			let cachedAt = results[0].cachedAt
			let minutesOld = Date().timeIntervalSince(cachedAt) / 60
			guard minutesOld < cachedExpiryMinutes else { return [] }
		}
		
		return results.map { $0.toArticle() }
	}
	
	func cacheSize(context: ModelContext) -> Int {
		let descriptor = FetchDescriptor<CachedArticle>()
		return (try? context.fetchCount(descriptor)) ?? 0
	}
	
	func clearAll(context: ModelContext) {
		try? context.delete(model: CachedArticle.self)
		try? context.save()
	}
	
	func deleteExisting(category: String, page: Int, context: ModelContext) {
		let descriptor = FetchDescriptor<CachedArticle>(
			predicate: #Predicate { $0.category == category && $0.page == page }
		)
		
		if let existing = try? context.fetch(descriptor) {
			existing.forEach { context.delete($0) }
		}
	}
}
