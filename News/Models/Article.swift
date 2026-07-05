//
//  Articles.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

struct Article: Decodable, Identifiable, Hashable {
	var id: UUID = UUID()
	let title: String
	let description: String?
	let url: String
	let urlToImage: String
	let publishedAt: String
	let content: String?
	let source: ArticleSource
	
	enum CodingKeys: String, CodingKey {
		case title, description, url, urlToImage, publishedAt, content, source
	}
}

struct ArticleSource: Decodable, Hashable {
	let id: String?
	let name: String
}
