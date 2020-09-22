//
//  TaskOptionsSupplementaryViews.swift
//  Shortlist
//
//  Created by Mark Wong on 21/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class BaseCollectionViewListHeader: UICollectionReusableView {
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Header"
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.font = ThemeV2.Header.SectionHeader.Font
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("Footer Invalid")
	}
	
	private func configure() {
		addSubview(titleLabel)
		
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
	}
	
	func updateLabel(with text: String) {
		titleLabel.text = text
	}
}

class BaseCollectionViewListFooter: UICollectionReusableView {
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Footer"
		label.numberOfLines = 0
		label.textColor = Theme.Font.FadedColor
		label.font = UIFont.preferredFont(forTextStyle: .footnote).with(weight: .regular)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("Footer Invalid")
	}
	
	private func configure() {
		addSubview(titleLabel)
		
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
	}
	
	func updateLabel(with text: String) {
		titleLabel.text = text
	}
}

