//
//  NetworkClient.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation

final class NetworkClient {
	static let shared = NetworkClient()
	private init() { }
	
	func fetch<T: Decodable>(_ type: T.Type, from endpoint: Endpoint) async throws -> T {
		guard let url = endpoint.url else {
			throw NewsError.invalidURL
		}
		
		let(data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NewsError.unknown(URLError(.badServerResponse))
		}
		
		switch httpResponse.statusCode {
			case 200:
				break
			case 429:
				throw NewsError.rateLimitExceeded
			default:
				throw NewsError.serverError(statusCode: httpResponse.statusCode)
		}
		
		do {
			let decoded = try JSONDecoder().decode(T.self, from: data)
			return decoded
		} catch {
			throw NewsError.decodingFailed
		}
	}
}
