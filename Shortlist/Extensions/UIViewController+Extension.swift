//
//  UIViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 30/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UIViewController {
	// https://stackoverflow.com/questions/7312059/programmatically-get-height-of-navigation-bar
	var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
	
}

extension UIBarButtonItem {
// https://stackoverflow.com/questions/43073738/change-size-of-uibarbuttonitem-image-in-swift-3
	static func menuButton(_ target: Any?, action: Selector, imageName: String, height: CGFloat) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = .white
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: height).isActive = true

        return menuBarItem
    }
}
