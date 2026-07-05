//
//  ViewState.swift
//  News
//
//  Created by Parth Patel on 2026-07-04.
//

import Foundation

enum ViewState<T> {
	case loading
	case success(T)
	case failure(NewsError)
	case empty
	case idle
}
