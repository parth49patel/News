//
//  ArticleDetailViewModel.swift
//  News
//
//  Created by Parth Patel on 2026-07-05.
//

import Foundation
import UIKit
import SwiftData

@Observable
class ArticleDetailViewModel {
	private(set) var isBookmarked: Bool = false
	private let article: Article
	
	init(article: Article) {
		self.article = article
	}
	
	func checkBookmarkStatus(context: ModelContext) {
		let url = article.url
		let descriptor = FetchDescriptor<BookmarkedArticle> (
			predicate: #Predicate { $0.url == url }
		)
		isBookmarked = (try? context.fetch(descriptor))?.isEmpty == false
	}
	
	func toggleBookmark(context: ModelContext) {
		let url = article.url
		let descriptor = FetchDescriptor<BookmarkedArticle> (
			predicate: #Predicate { $0.url == url }
		)
		
		if let existing = try? context.fetch(descriptor), !existing.isEmpty {
			existing.forEach { context.delete($0) }
			isBookmarked = false
		} else {
			let bookmark = BookmarkedArticle(article: article)
			context.insert(bookmark)
			isBookmarked = true
		}
		try? context.save()
	}
	
	func openInSafari() {
		guard let urlString = article.url,
				  let url = URL(string: urlString) else { return }
		UIApplication.shared.open(url)
	}
}
