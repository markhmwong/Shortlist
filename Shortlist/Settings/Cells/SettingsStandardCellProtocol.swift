//
//  SettingsStandardCellProtocol.swift
//  Shortlist
//
//  Created by Mark Wong on 14/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

protocol SettingsStandardCellProtocol {
	var nameLabel: UILabel { get set }
	var iconImage: UIImageView { get set }
	var chevron: UIImageView? { get set }
	
	
	func updateName(_ name: String)
	func updateIcon(_ iconName: String)
}
