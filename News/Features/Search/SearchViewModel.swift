//
//  SearchViewModel.swift
//  News
//
//  Created by Parth Patel on 2026-07-06.
//

import Foundation

@Observable
final class SearchViewModel {
	
	private(set) var state: ViewState<[Article]> = .idle
	private(set) var searchText: String = ""
	
	private var searchTask: Task<Void, Never>?
	private let service: NewsServiceProtocol
	private let monitor: NetworkMonitor
	
	init(
		service: NewsServiceProtocol = LiveNewsService(),
		monitor: NetworkMonitor = .shared
	) {
		self.service = service
		self.monitor = monitor
	}
	
	func search(query: String) {
		searchText = query
		guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
			state = .idle
			searchTask?.cancel()
			return
		}
		
		searchTask?.cancel()
		
		searchTask = Task {
			try? await Task.sleep(for: .milliseconds(300))
			guard !Task.isCancelled else { return }
			await performSearch(query: query)
		}
	}
	
	@MainActor
	func performSearch(query: String) async {
		guard monitor.isConnected else {
			state = .failure(.noInternet)
			return
		}
		
		do {
			let articles = try await service.searchArticles(query: query, page: 1)
			guard !Task.isCancelled else { return }
			
			if articles.isEmpty {
				state = .empty
			} else {
				state = .success(articles)
			}
		} catch let error as NewsError {
			state = .failure(error)
		} catch {
			state = .failure(.unknown(error))
		}
	}
	
	func clearAll() {
		searchTask?.cancel()
		searchText = ""
		state = .idle
	}
}
