//
//  SettingsDetailChevronCell.swift
//  Shortlist
//
//  Created by Mark Wong on 3/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsDetailedChevronCell: UITableViewCell, SettingsStandardCellProtocol {
	lazy var settingsValueLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.text = "1 3 3"
		label.textColor = Theme.Font.FadedColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var chevron: UIImageView? = {
		let image = UIImage(named: "ChevronRight.png")?.withRenderingMode(.alwaysTemplate)
		let chevron = UIImageView(frame: .zero)
		chevron.image = image
		return chevron
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupCellLayout()
	}
	
	 func setupCellLayout() {
		backgroundColor = Theme.GeneralView.background
		tintColor = Theme.Cell.iconColor
		textLabel?.textColor = Theme.Font.DefaultColor
		detailTextLabel?.textColor = Theme.Font.DefaultColor
		
		guard let _chevron = chevron else { return }
		_chevron.frame = CGRect(x: 0, y: 0, width: frame.height * 0.5, height: frame.height * 0.5)
		accessoryView = _chevron

	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		self.imageView?.bounds = CGRect(x: 0.0, y: 0.0, width: self.contentView.bounds.height * 0.6, height: self.contentView.bounds.height * 0.6)
	}
	
	func updateDetailsLabel(highPriorityLimit: String, mediumPriorityLimit: String, lowPriorityLimit: String) {
		let limitString = NSMutableAttributedString(string: "\(highPriorityLimit) ", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: Theme.Priority.highColor])
		limitString.append(NSMutableAttributedString(string: "\(mediumPriorityLimit) ", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: Theme.Priority.mediumColor]))
		limitString.append(NSMutableAttributedString(string: "\(lowPriorityLimit)", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: Theme.Priority.lowColor]))
		detailTextLabel?.attributedText = limitString
	}
	
	func updateName(_ name: String) {
		textLabel?.text = name
	}
	
	func updateIcon(_ iconName: String) {
		imageView?.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
		imageView?.tintColor = Theme.Cell.iconColor
	}
}
