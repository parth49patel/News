//
//  LoadingState.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import SwiftUI

struct LoadingState: View {
	
	var message: String = "Loading news..."
	
	var body: some View {
		VStack(spacing: 12) {
			ProgressView()
				.scaleEffect(1.2)
			
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
