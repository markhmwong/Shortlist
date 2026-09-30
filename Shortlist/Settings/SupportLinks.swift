//
//  SupportLinks.swift
//  Shortlist
//
//  Created by Mark Wong on 30/9/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit

/// The destinations behind the Settings → Support rows.
enum SupportLinks {

	static let social = URL(string: "https://x.com/_whizbangapps")!

	/// Opens the App Store review form directly. `requestReview()` is deliberately not used here as the system can silently skip it.
	static let review = URL(string: "https://apps.apple.com/app/id1480090462?action=write-review")!

	/// A feedback email that already says which device and release it is about. Kept in English: it is written for us to read.
	static var contact: URL {
		var components = URLComponents()
		components.scheme = "mailto"
		components.path = "hello@whizbangapps.dev"
		components.queryItems = [
			URLQueryItem(name: "subject", value: "Feedback"),
			URLQueryItem(name: "body", value: """
				Device: \(deviceModel) (iOS \(UIDevice.current.systemVersion))
				App version: \(versionString)

				Feedback:


				"""),
		]
		return components.url!
	}

	/// The hardware identifier, such as `iPhone17,1`. The simulator reports its host's architecture, so it is asked for the device it is pretending to be.
	private static var deviceModel: String {
		#if targetEnvironment(simulator)
		return ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Simulator"
		#else
		var systemInfo = utsname()
		uname(&systemInfo)
		return withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: Int(_SYS_NAMELEN)) { String(cString: $0) }
		}
		#endif
	}

	/// `CFBundleShortVersionString (CFBundleVersion)`
	private static var versionString: String {
		let info = Bundle.main.infoDictionary
		let version = info?["CFBundleShortVersionString"] as? String ?? "?"
		let build = info?["CFBundleVersion"] as? String ?? "?"
		return "\(version) (\(build))"
	}
}
