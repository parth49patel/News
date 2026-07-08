//
//  OnboardingPageView.swift
//  News
//
//  Created by Parth Patel on 2026-07-07.
//

import Foundation
import SwiftUI

struct OnboardingPage {
	let systemImage: String
	let title: String
	let description: String
}

struct OnboardingPageView: View {
	let page: OnboardingPage
	
	var body: some View {
		VStack(spacing: 24) {
			Spacer()
			
			Image(systemName: page.systemImage)
				.font(.system(size: 80))
				.foregroundStyle(.blue)
				.padding(.bottom, 8)
			
			Text(page.title)
				.font(.title)
				.fontWeight(.bold)
				.multilineTextAlignment(.center)
			
			Text(page.description)
				.font(.body)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.bottom, 32)
			
			Spacer()
		}
	}
}

#Preview {
	OnboardingPageView(page: OnboardingPage(
		systemImage: "newspaper",
		title: "Stay Informed",
		description: "NewsFlow brings you headlines from thousands of sources powered by NewsAPI")
	)
}
