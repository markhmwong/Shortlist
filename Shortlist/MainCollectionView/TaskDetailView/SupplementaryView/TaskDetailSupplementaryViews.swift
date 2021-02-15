//
//  TaskDetailHeader.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
	
	private lazy var priorityFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote).with(weight: .bold)
	
	lazy var headerTitle: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = priorityFont
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	func configure() {
		addSubview(headerTitle)
		
		NSLayoutConstraint.activate([
			headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
			headerTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0),
		])
	}
	
	func update(title: String) {
		self.headerTitle.text = title
	}

}

//class FooterSupplementaryView: UICollectionReusableView {
//
//	private let completeButton: NeuButton = NeuButton(title: "Mark As Complete")
//
//	static let reuseIdentifier = "title-supplementary-footer-reuse-identifier"
//
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		configure()
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("Footer Invalid")
//	}
//
//	private func configure() {
//
//		completeButton.contentEdgeInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
//
//		addSubview(completeButton)
//		completeButton.addTarget(self, action: #selector(handleCompleteButton), for: .touchDown)
//		completeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
//		completeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
//		completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
//		completeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
//	}
//}

