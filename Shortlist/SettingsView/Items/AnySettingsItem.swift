//
//  AnySettingsItem.swift
//  Shortlist
//
//  Created by Mark Wong on 11/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

struct AnySettingsItem: SettingsItemProtocol {
	private let _id: UUID
	private let _title: String
	private var _value: String
	private let _setItemType: (SettingsCellType) -> Void
	private let _getItemType: () -> SettingsCellType

	//	private let _description: String?
	private var _performAction: (() -> Void)?
	private let _hashValue: AnyHashable

	var id: UUID { _id }
	var title: String { _title }
	var value: String? {
		get {
			return _value
		}
		set {
			_value = newValue ?? "Unknown Value"
		}
	}

	var performAction: (() -> ())? {
		get {
			return _performAction
		}
		set {
			_performAction = newValue
		}
	}

	var itemType: SettingsCellType {
		get {
			return _getItemType()
		}
		set {
			_setItemType(newValue)
		}
	}

	// references actual object
	let baseItem: any SettingsItemProtocol

	//	var description: String? { _description }

	init<T: SettingsItemProtocol>(_ item: T) {
		_id = item.id
		_title = item.title
		_getItemType = { item.itemType }
		_setItemType = { newValue in
			var mutableItem = item
			mutableItem.itemType = newValue
		}
		//		_description = item.description
		_value = item.value ?? "Unknown Value"
		_performAction = item.performAction
		_hashValue = AnyHashable(item)
		self.baseItem = item
	}

	static func == (lhs: AnySettingsItem, rhs: AnySettingsItem) -> Bool {
		return lhs._hashValue == rhs._hashValue
	}

	func hash(into hasher: inout Hasher) {
		_hashValue.hash(into: &hasher)
	}
}
