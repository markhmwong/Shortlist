//
//  UINavigationController.swift
//  Shortlist
//
//  Created by Mark Wong on 2/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UINavigationController {
	func transparent() {
		navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
		navigationBar.shadowImage = UIImage()
		navigationBar.isTranslucent = true
		view.backgroundColor = .clear
	}
}
