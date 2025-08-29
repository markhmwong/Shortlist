//
//  CategoryIcons.swift
//  Shortlist
//
//  Created by Mark Wong on 19/1/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

enum AssetManager {

	enum OtherAssets: String {
		case alarm

		/// uses SF Symbols
		var iconName: String {
			switch self {
				case .alarm:
					return "alarm"
			}
		}
	}

	/// Preset categories
	enum CategoryAssets: String {
		case general
		case personal
		case family
		case work
		case home

		/// uses SF Symbols
		var iconName: String {
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
	}
}

