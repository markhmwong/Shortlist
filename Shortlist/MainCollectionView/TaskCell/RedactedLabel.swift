//
//  BlurredLabel.swift
//  Shortlist
//
//  Created by Mark Wong on 26/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class RedactedLabel: BaseLabel {
	
	func redactText(with text: String, redact: RedactState) {
		switch redact {
			case .censor:
				let redactedColor: UIColor = UIColor.black.withAlphaComponent(0.7)
				let attributes: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.backgroundColor: redactedColor, NSAttributedString.Key.foregroundColor: UIColor.clear])
				attributedText = attributes
			case .disclose:
				let redactedColor: UIColor = UIColor.black.withAlphaComponent(0.7)
				let attributes: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: redactedColor])
				attributedText = attributes
		}

	}
}
