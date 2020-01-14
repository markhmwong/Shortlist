//
//  SettingsDisclaimerCell.swift
//  Shortlist
//
//  Created by Mark Wong on 13/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsDisclaimerCell: CellBase {

	lazy var disclaimerLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		
		addSubview(disclaimerLabel)
		disclaimerLabel.fillSuperView()
	}
}

class SettingsDetailedChevronCell: CellBase, SettingsStandardCellProtocol {
	var chevron: UIImageView? = nil

	lazy var iconImage: UIImageView = {
		let chevron = UIImageView(frame: .zero)
		chevron.translatesAutoresizingMaskIntoConstraints = false
		return chevron
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	lazy var settingsValueLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.text = "3"
		label.textColor = Theme.Font.FadedColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		
		addSubview(nameLabel)
		addSubview(iconImage)
		
		tintColor = UIColor.white
		backgroundColor = .clear
		textLabel?.textColor = .white

		let image = UIImage(named: "ChevronRight.png")?.withRenderingMode(.alwaysTemplate)
		let _chevron = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.height * 0.5, height: frame.height * 0.5))
		_chevron.image = image
		accessoryView = _chevron
		
		settingsValueLabel.text = "unknown"
		addSubview(settingsValueLabel)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		iconImage.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -5.0), size: CGSize(width: bounds.height - 20.0, height: bounds.height - 20.0))
		nameLabel.anchorView(top: topAnchor, bottom: bottomAnchor, leading: iconImage.trailingAnchor, trailing: settingsValueLabel.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		let height = bounds.height - 40.0

		imageView?.frame = CGRect(x: 5.0, y: 5.0, width: height, height: height)
		settingsValueLabel.anchorView(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: accessoryView?.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0), size: .zero)
	}
	
	func updateDetailsLabel(_ string: String) {
		DispatchQueue.main.async {
			self.settingsValueLabel.text = "\(string)"
		}
	}
	
	func updateName(_ name: String) {
		nameLabel.text = name
	}
	
	func updateIcon(_ iconName: String) {
		iconImage.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
	}
}
