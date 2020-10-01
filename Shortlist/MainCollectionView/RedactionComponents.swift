//
//  RedactionComponents.swift
//  Shortlist
//
//  Created by Mark Wong on 31/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Factory and Redact Effect cases
struct RedactComponent: Hashable {
	var redactStyle: RedactStyle
	
	// Effect Factory
	var effect: RedactEffect {
		switch redactStyle {
			case .star:
				return RedactStar()
			case .highlight:
				return RedactHighlight()
			case .none:
				return RedactNone()
		}
	}
	
	// alpha level of feature icons on the home task cells
	var iconStatus: CGFloat {
		switch redactStyle {
			case .star, .highlight:
				return 1.0
			case .none:
				return 0.3
		}
	}
	
}

// MARK: - Redact base structs and protocols
protocol RedactEffect {
	var effect: [NSAttributedString.Key : Any] { get }
	func styleText(with text: String) -> NSMutableAttributedString?
}

struct RedactSmiles: RedactEffect {
	
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: ThemeV2.TextColor.DefaultColor, NSAttributedString.Key.font: ThemeV2.CellProperties.PrimaryFont]
	
	func styleText(with text: String) -> NSMutableAttributedString? {
		// replace string with stars. \\S
		return NSMutableAttributedString(string: text.replaceAllCharacters(with: "😃"), attributes: effect)
	}
}

struct RedactStar: RedactEffect {
	
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: ThemeV2.TextColor.DefaultColor]
	
	func styleText(with text: String) -> NSMutableAttributedString? {
		// replace string with stars. \\S
		return NSMutableAttributedString(string: text.replaceAllCharacters(with: "*"), attributes: effect)
	}
}

struct RedactHighlight: RedactEffect {
	
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: ThemeV2.TextColor.DefaultColor, NSAttributedString.Key.backgroundColor: ThemeV2.TextColor.DefaultColor]

	func styleText(with text: String) -> NSMutableAttributedString? {
		return NSMutableAttributedString(string: text, attributes: effect)
	}
}

struct RedactNone: RedactEffect {
	var effect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: ThemeV2.TextColor.DefaultColor, NSAttributedString.Key.backgroundColor: UIColor.clear]

	func styleText(with text: String) -> NSMutableAttributedString? {
		return NSMutableAttributedString(string: text, attributes: effect)
	}
}
