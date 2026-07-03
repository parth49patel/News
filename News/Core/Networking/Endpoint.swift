//
//  Endpoint.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

enum Endpoint {
	case topHeadlines(category: String, page: Int)
	case search(query: String, page: Int)
	case sources(category: String)
	
	var url: URL? {
		var components = URLComponents(string: Config.baseURL)
		
		switch self {
			case .topHeadlines(category: let category, page: let page):
				components?.path += "/top-headlines"
				components?.queryItems = [
					URLQueryItem(name: "category", value: category),
					URLQueryItem(name: "page", value: String(page)),
					URLQueryItem(name: "pageSize", value: "20"),
					URLQueryItem(name: "apiKey", value: Config.apiKey)
				
				]
				
			case .search(let query, let page):
				components?.path += "/everything"
				components?.queryItems = [
					URLQueryItem(name: "q", value: query),
					URLQueryItem(name: "page", value: String(page)),
					URLQueryItem(name: "pageSize", value: "20"),
					URLQueryItem(name: "apiKey", value: Config.apiKey)
				]
				
			case .sources(category: let category):
				components?.path += "/top-headlines/sources"
				components?.queryItems = [
					URLQueryItem(name: "category", value: category),
					URLQueryItem(name: "apiKey", value: Config.apiKey)
				]
		}
		
		return components?.url
	}
}
