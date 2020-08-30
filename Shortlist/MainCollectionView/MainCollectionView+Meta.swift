//
//  MainCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum TaskSection: Int, CaseIterable {
	case high = 0
	case medium
	case low
}

enum RedactState: Int {
	case censor = 0
	case disclose
}

enum RedactStyle: Int {
	case star = 0 //hidden
	case highlight // hidden
	case disclose // total transparency
}

struct RedactComponent: Hashable {
	var redactStyle: RedactStyle
	
	// Effect Factory
	var effect: RedactEffect {
		switch redactStyle {
			case .star:
				return RedactStar()
			case .highlight:
				return RedactHighlight()
			case .disclose:
				return RedactNone()
		}
	}
	
	// alpha level of feature icons on the home task cells
	var iconStatus: CGFloat {
		switch redactStyle {
			case .star, .highlight:
				return 1.0
			case .disclose:
				return 0.3
		}
	}
	
}

protocol RedactEffect {
	var effect: [NSAttributedString.Key : Any] { get }
	func styleText(with text: String) -> NSMutableAttributedString?
}



struct RedactStar: RedactEffect {
	
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
	
	func styleText(with text: String) -> NSMutableAttributedString? {
		// replace string with stars. \\S
		return NSMutableAttributedString(string: text.replaceAllCharacters(with: "*"), attributes: effect)
	}
}

struct RedactHighlight: RedactEffect {
	
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.backgroundColor: UIColor.black]

	func styleText(with text: String) -> NSMutableAttributedString? {
		return NSMutableAttributedString(string: text, attributes: effect)
	}
}

struct RedactNone: RedactEffect {
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.backgroundColor: UIColor.clear]

	func styleText(with text: String) -> NSMutableAttributedString? {
		return NSMutableAttributedString(string: text, attributes: effect)
	}
}

struct TaskItem: Hashable {
	
	var id: UUID = UUID()
	var title: String
	var notes: String
	var priority: Priority
	var completionStatus: Bool
	var reminder: String
//	var redacted: RedactState // because it's stored in Core Data and CoreData doesn't store enums, we'll use an integer to represent it and then assign it to the enum
//	var redactStyle: Int?
	var redaction: RedactComponent
	
	static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
		return lhs.id == rhs.id
	}
}

// Core Data for redact
// an attribute to represent the style and whether or not it is censored

// enum -> Struct -> state pattern
