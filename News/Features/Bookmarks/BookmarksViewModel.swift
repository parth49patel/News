//
//  BookmarksViewModel.swift
//  News
//
//  Created by Parth Patel on 2026-07-06.
//

import Foundation
import SwiftData

@Observable
final class BookmarksViewModel {
	
	func delete(_ article: BookmarkedArticle, context: ModelContext) {
		context.delete(article)
		try? context.save()
	}
	
	func deleteAll(context: ModelContext) {
		try? context.delete(model: BookmarkedArticle.self)
		try? context.save()
	}
}
