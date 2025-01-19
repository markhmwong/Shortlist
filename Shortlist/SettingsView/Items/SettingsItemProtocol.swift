//
//  SettingsItemProtocol.swift
//  Shortlist
//
//  Created by Mark Wong on 11/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

protocol SettingsItemProtocol: Hashable, Identifiable {
	var id: UUID { get }
	var title: String { get }
	//	var section: SettingsViewModel.SettingsSection { get set }
	var value: String? { get set }
	var itemType: SettingsCellType { get set }

	var performAction: (() -> ())? { get set }
}
