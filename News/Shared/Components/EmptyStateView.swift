//
//  EmptyStateView.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import SwiftUI

struct EmptyStateView: View {
	let title: String
	let message: String
	let systemImage: String
	
	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: systemImage)
				.font(.system(size: 48))
				.foregroundStyle(.secondary)
			Text(title)
				.font(.headline)
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 32)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
