//
//  ImageCache.swift
//  News
//
//  Created by Parth Patel on 2026-07-09.
//

import UIKit

final class ImageCache {
	static let shared = ImageCache()
	private init() { }
	
	private let memoryCache = NSCache<NSString, UIImage>()
	private let diskCacheURL: URL = {
		let cached = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		let directory = cached.appendingPathComponent("ImageCache")
		return directory
	}()
	
	func image(for urlString: String) async -> UIImage? {
		let key = NSString(string: urlString)
		if let cached = memoryCache.object(forKey: key) { return cached }
		if let diskImage = loadFromDisk(key: urlString) {
			memoryCache.setObject(diskImage, forKey: key)
			return diskImage
		}
		
		guard let url = URL(string: urlString) else { return nil }
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let image = UIImage(data: data)
			memoryCache.setObject(image!, forKey: key)
			saveToDisk(key: urlString, image: image!)
			return image
		} catch { return nil }
	}
	
	func clearAll() {
		memoryCache.removeAllObjects()
		try? FileManager.default.removeItem(at: diskCacheURL)
		try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
	}
	
	func diskURL(key: String) -> URL {
		let filename = String(key.hashValue)
		return diskCacheURL.appendingPathComponent(filename)
	}
	
	func loadFromDisk(key: String) -> UIImage? {
		let url = diskURL(key: key)
		guard let data = try? Data(contentsOf: url) else { return nil }
		return UIImage(data: data)
	}
	
	func saveToDisk(key: String, image: UIImage) {
		let url = diskURL(key: key)
		guard let data = image.jpegData(compressionQuality: 0.8) else { return }
		try? data.write(to: url)
	}
}
