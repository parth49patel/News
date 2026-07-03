//
//  NetworkMonitor.swift
//  News
//
//  Created by Parth Patel on 2026-07-03.
//

import Foundation
import Network

@Observable
final class NetworkMonitor {
	static let shared = NetworkMonitor()
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")
	
	private(set) var isConnected: Bool = true
	private(set) var connectionType: ConnectionType = .unknown
	
	private init() {
		startMonitoring()
	}
	
	enum ConnectionType {
		case wifi
		case cellular
		case ethernet
		case unknown
	}
	
	private func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.async {
				self?.isConnected = path.status == .satisfied
				self?.connectionType = self?.getConnectionType(path) ?? .unknown
			}
		}
		monitor.start(queue: queue)
	}
	
	private func getConnectionType(_ path: NWPath) -> ConnectionType {
		if path.usesInterfaceType(.wifi) {
			return .wifi
		} else if path.usesInterfaceType(.cellular) {
			return .cellular
		} else if path.usesInterfaceType(.wiredEthernet) {
			return .ethernet
		}
		return .unknown
	}
	
	func stopMonitoring() {
		monitor.cancel()
	}
	
}
