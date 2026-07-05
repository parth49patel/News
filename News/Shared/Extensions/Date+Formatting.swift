//
//  Date+Formatting.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import Foundation

extension String {
	func timeAgo() -> String {
		let formatter = ISO8601DateFormatter()
		guard let date = formatter.date(from: self) else { return self }
		
		let components = Calendar.current.dateComponents([.day, .minute, .hour], from: date, to: Date())
		
		if let day = components.day, day > 0 {
			return day == 1 ? "Yesterday" : "\(day) days ago"
		} else if let hour = components.hour, hour > 0 {
			return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
		} else if let minute = components.minute, minute > 0 {
			return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
		}
		return "Just now"
	}
}
