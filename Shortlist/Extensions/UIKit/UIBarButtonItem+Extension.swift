//
//  UIBarButtonItem.swift
//  Shortlist
//
//  Created by Mark Wong on 17/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit.UIBarButtonItem

extension UIBarButtonItem {
	
	func taskOptionsButton(target: Any?, action: Selector) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
		return UIBarButtonItem(customView: button)
	}
	
	func optionsButton(target: Any?, action: Selector) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "gearshape.2.fill"), for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
		return UIBarButtonItem(customView: button)
	}
	
	func createTaskButton(target: Any?, action: Selector) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
		return UIBarButtonItem(customView: button)
	}
	
	func donateButton(target: Any?, action: Selector) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "gift.fill"), for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = ThemeV2.ButtonColor.DonateColor
		return UIBarButtonItem(customView: button)
	}
	
	func backButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
        return UIBarButtonItem(customView: button)
	}
	
	func cancelButton(target: Any?, action: Selector) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setTitle("Dismiss", for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
		return UIBarButtonItem(customView: button)
	}
	
	static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
        return UIBarButtonItem(customView: button)
    }
}
