//
//  OnboardingView.swift
//  News
//
//  Created by Parth Patel on 2026-07-07.
//

import SwiftUI

struct OnboardingView: View {
	
	@AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding: Bool = false
	@AppStorage(UserDefaultsKeys.preferredCategories) private var preferredCategories: String = "technology,business"
	
	@State private var currentPage: Int = 0
	@State private var selectedCategories: Set<String> = ["technology", "business"]
	
	private let pages: [OnboardingPage] = [
		OnboardingPage(
			systemImage: "newspaper.fill",
			title: "Stay Informed",
			description: "NewsFlow brings you headlines from thousands of sources powered by NewsAPI"
		),
		OnboardingPage(
			systemImage: "bookmark.fill",
			title: "Save For Later",
			description: "Bookmark any article to read it later, even without internet"
		)
	]
	
	private let allCategories = [
		"technology", "business", "sports", "entertainment", "health", "science"
	]
	
    var body: some View {
		VStack(spacing: 0) {
			HStack {
				ForEach(0..<3) { index in
					Capsule()
						.fill(index == currentPage ? .blue : Color(.systemGray4))
						.frame(width: index == currentPage ? 24 : 8, height: 8)
						.animation(.spring(), value: currentPage)
				}
			}
			
			TabView(selection: $currentPage) {
				ForEach(0..<pages.count, id: \.self) { index in
					OnboardingPageView(page: pages[index])
						.tag(index)
				}
				categorySelectionPage
					.tag(2)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			
			Button {
				if currentPage < 2 {
					withAnimation {
						currentPage += 1
					}
				} else {
					completedOnboarding()
				}
			} label: {
				Text(currentPage < 2 ? "Next" : "Get Started")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.blue)
					.foregroundStyle(.white)
					.clipShape(RoundedRectangle(cornerRadius: 14))
					.padding(.horizontal, 24)
			}
			.padding(.bottom, 32)
		}
    }
	
	private var categorySelectionPage: some View {
		VStack(spacing: 24) {
			Spacer()
			
			Image(systemName: "square.grid.2x2.fill")
				.font(.system(size: 80))
				.foregroundStyle(.blue)
			Text("Choose Your Interests")
				.font(.title)
				.bold()
			Text("Select categories to personalise your headline feed")
				.font(.body)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 32)
			
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
				ForEach(allCategories, id: \.self) { category in
					Button {
						if selectedCategories.contains(category) {
							if selectedCategories.count > 1 {
								selectedCategories.remove(category)
							}
						} else {
							selectedCategories.insert(category)
						}
					} label: {
						Text(category.capitalized)
							.font(.subheadline)
							.fontWeight(.medium)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 12)
							.background(
								selectedCategories.contains(category) ? Color.blue : Color(.systemGray6)
							)
							.foregroundStyle(
								selectedCategories.contains(category) ?
									.white : .primary
							)
							.clipShape(RoundedRectangle(cornerRadius: 10))
					}
				}
			}
			.padding(.horizontal, 24)
			
			Spacer()
		}
	}
	
	private func completedOnboarding() {
		preferredCategories = selectedCategories.joined(separator: ",")
		hasCompletedOnboarding = true
	}
}

#Preview {
    OnboardingView()
}
