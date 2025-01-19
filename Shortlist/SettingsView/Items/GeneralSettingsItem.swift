//
//  GeneralSettingsItem.swift
//  Shortlist
//
//  Created by Mark Wong on 11/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

struct GeneralSettingsItem: SettingsItemProtocol {

	var id: UUID = UUID()
	/// the title of the cell
	var title: String

	/// the section where the cell appears
	var section: SettingsViewModel.SettingsSection

	/// the value of the cell
	var value: String?

	/// the cell type (slider, label)
	var itemType: SettingsCellType

	/// whether the cell needs to perform an action
	var performAction: (() -> ())?

	// default font of the cell
	var font: UIFont = .preferredFont(forTextStyle: .body)

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(title)
		hasher.combine(value)
	}

	static func == (lhs: GeneralSettingsItem, rhs: GeneralSettingsItem) -> Bool {
		return lhs.id == rhs.id &&
		lhs.title == rhs.title &&
		lhs.value == rhs.value
	}

	@discardableResult
	mutating func titleFontConfig(size: CGFloat = 0, textStyle: UIFont.TextStyle = .body, weight: UIFont.Weight = .regular, isItalic: Bool = false) -> Self {
		var descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
//			.withSize(size)

		if isItalic {
			descriptor = descriptor.withSymbolicTraits(.traitItalic) ?? descriptor
		}
		self.font = UIFont(descriptor: descriptor, size: size).withWeight(weight)
		return self
	}
}
