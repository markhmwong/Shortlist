//
//  AnySettingsItem.swift
//  Shortlist
//
//  Created by Mark Wong on 11/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

/// A type-erased wrapper for any `SettingsItemProtocol` conforming item.
/// This allows for heterogeneous collections of settings items, enabling
/// the use of different types of settings items in a single collection
/// while maintaining type safety and functionality.
/// /// Usage:
/// ```swift
/// let items: [AnySettingsItem] = [
///     AnySettingsItem(SettingsTaskLimitItem(title: "Task Limit", value: "10", itemType: .text)),
///     AnySettingsItem(GeneralSettingsItem(title: "About", itemType: .label, performAction: { print("About tapped") }))
/// ]
/// Accessing properties
/// for item in items {
///     print("Title: \(item.title), Value: \(item.value ?? "No Value")")
///     item.performAction?()
///     print("Item Type: \(item.itemType)")
///     print("Item ID: \(item.id)")
///     print("Hash Value: \(item.hashValue)")
///     print("Base Item: \(item.baseItem)")
///     // Use item.baseItem to access the original settings item
///     // Note: Ensure to cast baseItem to the specific type if needed
///     if let specificItem = item.baseItem as? SettingsTaskLimitItem {
///         print("Specific Item Title: \(specificItem.title)")
///     }
/// }
/// ```
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
