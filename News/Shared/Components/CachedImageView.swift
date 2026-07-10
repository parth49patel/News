//
//  CachedImageView.swift
//  News
//
//  Created by Parth Patel on 2026-07-09.
//

import SwiftUI

struct CachedImageView: View {
	
	let urlString: String?
	let contentMode: ContentMode
	
	@State private var image: UIImage? = nil
	@State private var isLoading: Bool = false
	
	init(urlString: String?, contentMode: ContentMode = .fill) {
		self.urlString = urlString
		self.contentMode = contentMode
	}

    var body: some View {
		Group {
			if let image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: contentMode)
			} else if isLoading {
				placeHolder
					.overlay(ProgressView())
			} else {
				placeHolder
			}
		}
		.task {
			await loadImage()
		}
    }
	
	private var placeHolder: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(Color(.systemGray6))
			.overlay {
				Image(systemName: "newspaper")
					.foregroundStyle(.secondary)
			}
	}
	
	private func loadImage() async {
		guard let urlString, !urlString.isEmpty else { return }
		isLoading = true
		image = await ImageCache.shared.image(for: urlString)
		isLoading = false
	}
}

#Preview {
	CachedImageView(urlString: "", contentMode: .fill)
}
