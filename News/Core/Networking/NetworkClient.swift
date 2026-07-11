//
//  NetworkClient.swift
//  News
//
//  Created by Parth Patel on 2026-06-30.
//

import Foundation
import SwiftUI

final class NetworkClient {
	static let shared = NetworkClient()
	private init() { }
	
	@AppStorage(UserDefaultsKeys.dailyRequestCount) private var dailyRequestCount: Int = 0
	@AppStorage(UserDefaultsKeys.lastRequestDate) private var lastRequestDate: String = ""
	private let maxRetries: Int = 3
	
	private func trackRequest() {
		let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
		if today != lastRequestDate {
			dailyRequestCount = 0
			lastRequestDate = today
		}
		dailyRequestCount += 1
	}
	
	func fetch<T: Decodable>(_ type: T.Type, from endpoint: Endpoint) async throws -> T {
		guard let url = endpoint.url else {
			throw NewsError.invalidURL
		}
		
		var attempt = 0
		
		while true {
			do {
				let(data, response) = try await URLSession.shared.data(from: url)
				
				guard let httpResponse = response as? HTTPURLResponse else {
					throw NewsError.unknown(URLError(.badServerResponse))
				}
				
				switch httpResponse.statusCode {
					case 200:
						trackRequest()
						return try JSONDecoder().decode(T.self, from: data)
					case 429:
						throw NewsError.rateLimitExceeded
					default:
						throw NewsError.serverError(statusCode: httpResponse.statusCode)
				}
			} catch {
				attempt += 1
				guard attempt < maxRetries && isRetryable(error) else { throw error}
				let delay = UInt64(pow(2.0, Double(attempt - 1)) * 1_000_000_000)
				try await Task.sleep(nanoseconds: delay)
			}
		}
	}
	
	private func isRetryable(_ error: Error) -> Bool {
		if let urlError = error as? URLError {
			switch urlError.code {
				case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotConnectToHost, .dnsLookupFailed: return true
				default: return false
			}
		}
		if case NewsError.serverError = error { return true }
		return false
	}
}
