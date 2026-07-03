//
//  NewsResponse.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

struct NewsResponse: Decodable {
	let status: String
	let totalResults: Int?
	let articles: [Article]
}
