//
//  NewsError.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

enum NewsError: LocalizedError {
	case invalidURL
	case noInternet
	case rateLimitExceeded
	case decodingFailed
	case serverError(statusCode: Int)
	case unknown(Error)
	
	var errorDescription: String? {
		switch self {
			case .invalidURL:
				return "The request URL was invalid."
			case .noInternet:
				return "No internet connection. Showing cached content."
			case .rateLimitExceeded:
				return "Daily request limit reached. Try again tomorrow."
			case .decodingFailed:
				return "Failed to decode the server response."
			case .serverError(let code):
				return "Server returned an error: \(code)"
			case .unknown(let error):
				return error.localizedDescription
		}
	}
}
