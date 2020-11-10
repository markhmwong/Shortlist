//
//  VersionInformation.swift
//  Shortlist
//
//  Created by Mark Wong on 3/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation
enum Patch: Int {
	case major
	case minor
}

struct Feature: Decodable {
	let title: String
	let description: String
	let type: Int // 0 Major, 1 Minor
	
	enum CodingKeys: String, CodingKey {
		case title = "title"
		case description = "description"
		case type = "type"
	}
}

struct ChangeLog: Decodable {
	let version: String
	let date: Date
	let versionDescription: String
	var feature: [Feature]
	
	init(version: String, date: Date, versionDescription: String, feature: [Feature]) {
		self.version = version
		self.date = date
		self.versionDescription = versionDescription
		self.feature = feature
	}
	
	enum CodingKeys: String, CodingKey {
		case version = "version"
		case date = "date"
		case versionDescription = "version_description"
		case feature = "feature"
	}
}
