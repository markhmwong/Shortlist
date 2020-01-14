//
//  SettingsStandardCell.swift
//  Shortlist
//
//  Created by Mark Wong on 14/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsStandardCell: UITableViewCell, SettingsStandardCellProtocol {
	
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
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupCellLayout() {
		backgroundColor = .clear
		
		accessoryView = chevron
		tintColor = .white
		addSubview(iconImage)
		addSubview(nameLabel)
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		guard let _chevron = chevron else { return }
		_chevron.frame = CGRect(x: 0, y: 0, width: frame.height * 0.5, height: frame.height * 0.5)
		
		iconImage.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -5.0), size: CGSize(width: bounds.height - 20.0, height: bounds.height - 20.0))
		nameLabel.anchorView(top: topAnchor, bottom: bottomAnchor, leading: iconImage.trailingAnchor, trailing: _chevron.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
	}
	
	func updateIcon(_ iconName: String) {
		iconImage.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
	}
	
	func updateName(_ name: String) {
		nameLabel.text = name
	}
}
