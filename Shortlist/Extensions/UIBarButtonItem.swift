//
//  UIBarButtonItem.swift
//  Shortlist
//
//  Created by Mark Wong on 17/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit.UIBarButtonItem

extension UIBarButtonItem {
	
	static func menuButton(_ target: Any?, action: Selector, imageName: String, height: CGFloat) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = UIColor.white
		
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: height).isActive = true

        return menuBarItem
    }
	
}
