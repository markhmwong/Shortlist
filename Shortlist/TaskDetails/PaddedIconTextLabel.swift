//
//  CustomLabelView.swift
//  Shortlist
//
//  Created by Mark Wong on 19/1/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//


import UIKit

class PaddedIconTextLabel: UIView {

	private struct ViewConstants {
		static let stackViewSpacing: CGFloat = 8.0

		static let horizontalPadding: CGFloat = 10.0
		static let verticalPadding: CGFloat = 4.0
	}

	private let stackView = UIStackView()
	private let iconImageView = UIImageView()
	private let textLabel = UILabel()

	init(iconName: String, text: String, textStyle: UIFont.TextStyle) {
		super.init(frame: .zero)

		// setup container view
		backgroundColor = .systemBlue
		layer.cornerRadius = 8
		layer.masksToBounds = true
		translatesAutoresizingMaskIntoConstraints = false

		setupView(iconName: iconName, text: text, textStyle: textStyle)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	private func setupView(iconName: String, text: String, textStyle: UIFont.TextStyle) {


		// Configure the stack view
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = ViewConstants.stackViewSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		// Configure the icon image view
		let configuration = UIImage.SymbolConfiguration(textStyle: .body)
		let iconImage = UIImage(systemName: iconName, withConfiguration: configuration)

		iconImageView.image = iconImage
		iconImageView.tintColor = .white
		iconImageView.contentMode = .scaleAspectFit
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

		// Configure the text label
		textLabel.text = text
		textLabel.font = UIFont.preferredFont(forTextStyle: textStyle)
		textLabel.textColor = .white
		textLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

		// Add the subviews to the stack view
		stackView.addArrangedSubview(iconImageView)
		stackView.addArrangedSubview(textLabel)



		// Set up constraints
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.horizontalPadding),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.horizontalPadding),
			stackView.topAnchor.constraint(equalTo: topAnchor, constant: ViewConstants.verticalPadding),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewConstants.verticalPadding),
		])
	}

	public func updateText(text: String) {
		textLabel.text = text
	}
}
