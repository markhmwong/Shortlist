//
//  BlurredLabel.swift
//  Shortlist
//
//  Created by Mark Wong on 26/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit


class RedactedLabel: BaseLabel {
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func redactText(with text: String, redactWithEffect effect: RedactEffect) {
		attributedText = effect.styleText(with: text)
	}
}
