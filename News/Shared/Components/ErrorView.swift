//
//  ErrorView.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import SwiftUI

struct ErrorView: View {
	let message: String
	let onRetry: () -> Void
	
	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle")
				.font(.system(size: 48))
				.foregroundStyle(.orange)
			
			Text("Something went wrong")
				.font(.headline)
			
			Text(message)
				.font(.subheadline)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 32)
			
			Button("Try Again") {
				onRetry()
			}
			.buttonStyle(.borderedProminent)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
