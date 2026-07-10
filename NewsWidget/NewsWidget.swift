//
//  NewsWidget.swift
//  NewsWidget
//
//  Created by Parth Patel on 2026-07-08.
//

import WidgetKit
import SwiftUI

struct NewsWidgetEntry: TimelineEntry {
	let date: Date
	let articles: [ArticleEntry]

	struct ArticleEntry {
	   let title: String
	   let source: String
	   let url: String
	}

	static var placeholder: NewsWidgetEntry {
	   NewsWidgetEntry(
		   date: Date(),
		   articles: [
			   ArticleEntry(title: "Apple announces major iOS update with new AI features", source: "TechCrunch", url: ""),
			   ArticleEntry(title: "Markets rally as inflation data comes in lower than expected", source: "Bloomberg", url: ""),
			   ArticleEntry(title: "Scientists discover new approach to treating common diseases", source: "Reuters", url: "")
		   ]
	   )
	}
}

struct NewsWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> NewsWidgetEntry {
		.placeholder
	}
	
	func getSnapshot(in context: Context, completion: @escaping (NewsWidgetEntry) -> Void) {
		completion(.placeholder)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<NewsWidgetEntry>) -> Void)  {
		Task {
			let articles = await fetchHeadlines()
			let entry = NewsWidgetEntry(date: Date(), articles: articles)
			let refresh = Calendar.current.date(byAdding: .hour, value: 2, to: Date())!
			let timeline = Timeline(entries: [entry], policy: .after(refresh))
			completion(timeline)
		}
	}
	
	private func fetchHeadlines() async -> [NewsWidgetEntry.ArticleEntry] {
		let category = UserDefaults(suiteName: "group.com.pp.News")?
			.string(forKey: "preferredCategories")?
			.split(separator: ",")
			.map(String.init)
			.first ?? "technology"
		
		guard let url = URL(string: "https://newsapi.org/v2/top-headlines?category=\(category)&pageSize=3&apiKey=\(Config.apiKey)") else {
			return NewsWidgetEntry.placeholder.articles
		}
				
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let response = try JSONDecoder().decode(NewsResponse.self, from: data)
			return response.articles.prefix(3).compactMap { article in
				guard let title = article.title else { return nil }
				return NewsWidgetEntry.ArticleEntry(
					title: title,
					source: article.source.name,
					url: article.url ?? ""
				)
			}
		} catch {
			return NewsWidgetEntry.placeholder.articles
		}
	}
}

struct NewsWidgetEntryView : View {
    var entry: NewsWidgetEntry
	@Environment(\.widgetFamily) var family
	
    var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "newspaper.fill")
					.foregroundStyle(.blue)
				Text("Top Headlines")
					.font(.caption)
					.foregroundStyle(.blue)
					.fontWeight(.semibold)
				Spacer()
			}
			Divider()
			
			ForEach(Array(entry.articles.prefix(articleCount).enumerated()), id: \.offset) { _, article in
				VStack(alignment: .leading, spacing: 2) {
					Text(article.title)
					   .font(.caption)
					   .fontWeight(.medium)
					   .lineLimit(2)
				   Text(article.source)
					   .font(.caption2)
					   .foregroundStyle(.secondary)
			   }
			   
			   if article.title != entry.articles.prefix(articleCount).last?.title {
				   Divider()
			   }
			}
			Spacer()
		}
		.padding()
    }
	
	private var articleCount: Int {
		switch family {
			case .systemSmall: return 1
			case .systemMedium: return 2
			case .systemLarge: return 3
			default: return 2
		}
	}
}

struct NewsWidget: Widget {
    let kind: String = "NewsWidget"

    var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: NewsWidgetProvider()) { entry in
			NewsWidgetEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
		}
        .configurationDisplayName("Top Headlines")
        .description("Stay updated with the latest news.")
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    NewsWidget()
} timeline: {
	NewsWidgetEntry(
			date: Date(),
			articles: [
				NewsWidgetEntry.ArticleEntry(
					title: "Apple announces major iOS update",
					source: "TechCrunch",
					url: ""
				),
				NewsWidgetEntry.ArticleEntry(
					title: "Markets rally as inflation drops",
					source: "Bloomberg",
					url: ""
				)
			]
		)
}
