//
//  SupplementaryView.swift
//  Shortlist
//
//  Created by Mark Wong on 8/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
// used for whats new and tip jar views
class SupplementaryViewHeader: UICollectionReusableView {

	private lazy var briefLabel: BaseLabel = {
		let label = BaseLabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
		return label
	}()

	private lazy var subtitleLabel: BaseLabel = {
		let label = BaseLabel()
		label.text = ""
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
		return label
	}()

	private lazy var titleLabel: BaseLabel = {
		let label = BaseLabel()
		label.text = ""
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureHeader()
	}

	required init?(coder: NSCoder) {
		fatalError("Footer Invalid")
	}

	private func configureHeader() {
		addSubview(titleLabel)
		addSubview(subtitleLabel)
		addSubview(briefLabel)

		briefLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10).isActive = true
		briefLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
		briefLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
		briefLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true

		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true

		subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
		subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
		subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true

	}

	func updateSubtitleLabel(with text: String) {
		subtitleLabel.text = text
	}

	func updateBriefLabel(with text: String) {
		briefLabel.text = text
	}

	func updateTitleLabel(with text: String) {
		titleLabel.text = text
	}
}
