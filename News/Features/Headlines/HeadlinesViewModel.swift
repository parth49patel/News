//
//  HeadlinesViewModel.swift
//  News
//
//  Created by Parth Patel on 2026-07-05.
//

import Foundation
import SwiftData

@Observable
final class HeadlinesViewModel {
	
	private(set) var state: ViewState<[Article]> = .idle
	private(set) var selectedCategory: String = "business"
	private(set) var currentPage: Int = 1
	private(set) var hasMorePages: Bool = true
	private(set) var totalResults: Int = 0
		
	var categories: [String] {
		let stored = UserDefaults.standard.string(forKey: UserDefaultsKeys.preferredCategories) ?? "technology,business"
		return stored
			.split(separator: ",")
			.map(String.init)
	}
	
	private let monitor: NetworkMonitor
	private let cache: CacheManager
	private let service: NewsServiceProtocol
	
	init(
		monitor: NetworkMonitor = .shared,
		cache: CacheManager = .shared,
		service: NewsServiceProtocol = LiveNewsService()
	) {
		self.monitor = monitor
		self.cache = cache
		self.service = service
	}
	
	@MainActor
	func loadHeadlines(context: ModelContext) async {
		// Check cache FIRST regardless of connectivity
		let cached = cache.fetch(category: selectedCategory, page: currentPage, context: context)
		if !cached.isEmpty {
			state = .success(cached)
			// If online, silently refresh in background
			if monitor.isConnected {
				await refreshInBackground(context: context)
			}
			return
		}
		
		// No cache - now check connectivity
		guard monitor.isConnected else {
			state = .failure(.noInternet)
			return
		}
		
		// Online and no cache - fetch fresh
		state = .loading
		do {
			let articles = try await service.fetchHeadlines(category: selectedCategory, page: currentPage)
			
			if articles.isEmpty {
				state = .empty
			} else {
				cache.save(articles: articles, category: selectedCategory, page: currentPage, context: context)
				state = .success(articles)
			}
		} catch let error as NewsError {
			state = .failure(error)
		} catch {
			state = .failure(.unknown(error))
		}
		
	}
	
	
	// Silent backround refresh - user sees cached content instantly
	// while fresh content loads behind the scenes
	@MainActor
	func refreshInBackground(context: ModelContext) async {
		guard monitor.isConnected else { return }
		do {
			let articles = try await service.fetchHeadlines(category: selectedCategory, page: currentPage)
			
			if !articles.isEmpty {
				cache.save(articles: articles, category: selectedCategory, page: currentPage, context: context)
				state = .success(articles)
			}
		} catch {
			// Silent failure - user already sees cached content
			// Don't change state on background refresh failure
		}
	}
	
	@MainActor
	func loadMore(context: ModelContext) async {
		guard hasMorePages else { return }
		guard case .success(let current) = state else { return }
		guard monitor.isConnected else { return }
		
		let nextPage = currentPage + 1
		
		do {
			let newArticles = try await service.fetchHeadlines(category: selectedCategory, page: nextPage)
			
			guard !newArticles.isEmpty else {
				hasMorePages = false
				return
			}
			
			currentPage = nextPage
			cache.save(articles: newArticles, category: selectedCategory, page: nextPage, context: context)
			state = .success(current + newArticles)
		} catch {
			
		}
	}
	
	@MainActor
	func selectCategory(_ category: String, context: ModelContext) async {
		guard category != selectedCategory else { return }
		selectedCategory = category
		currentPage = 1
		hasMorePages = true
		state = .loading
		await loadHeadlines(context: context)
	}
	
	@MainActor
	func refresh(context: ModelContext) async {
		currentPage = 1
		hasMorePages = true
		cache.clearAll(context: context)
		await loadHeadlines(context: context)
	}
}
