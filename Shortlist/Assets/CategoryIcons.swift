//
//  CategoryIcons.swift
//  Shortlist
//
//  Created by Mark Wong on 19/1/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

public enum AssetManager {

	public enum OtherAssets: String {
		case alarm

		/// uses SF Symbols
		public var iconName: String {
			switch self {
				case .alarm:
					return "alarm"
			}
		}
	}

	/// Preset categories
	public enum Category: Int16, CaseIterable {
		case general
		case personal
		case family
		case work
		case home

		/// uses SF Symbols
		public var symbol: String {
			switch self {
				case .general:
					return "text.document"
				case .home:
					return "house"
				case .personal:
					return "person"
				case .family:
					return "figure.2.and.child.holdinghands"
				case .work:
					return "building.2"
			}
		}

		public var name: String {
			switch self {
				case .general:
					return "General"
				case .home:
					return "Home"
				case .personal:
					return "Personal"
				case .family:
					return "Family"
				case .work:
					return "Work"
			}
		}
	}
}

