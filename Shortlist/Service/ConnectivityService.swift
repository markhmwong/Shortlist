//
//  ConnectivityService.swift
//  Shortlist
//
//  Created by Mark Wong on 14/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Network

enum NetworkStatus {
	case Connected
	case Standby
	case Failure
}

class Connectivity: NSObject {
	
	private let monitor = NWPathMonitor()
	
	var status: NetworkStatus
	
	override init() {
		status = .Standby
	}
	
	func start(completionHandler: @escaping() -> ()) {
		monitor.pathUpdateHandler = { path in
			
			switch path.status {
				case .satisfied:
					self.status = .Connected
					completionHandler()
				case .requiresConnection:
					()
				case .unsatisfied:
					()
				@unknown default:
					()
			}
		}
		
		let queue = DispatchQueue.global(qos: .background)
		monitor.start(queue: queue)
	}
	
	func getCurrentNetworkStatus() -> NetworkStatus {
		return status
	}
	
	func removeMonitor() {
		monitor.cancel()
	}
}
