//
//  UIColor+AppColors.swift
//  Shortlist
//
//  Created by Mark Wong on 30/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

extension UIColor {
	// MARK: Defined colours

	static let faintYellow: UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.4, alpha: 1.0)

	static let goldenYellow: UIColor = UIColor(red: 0.6588, green: 0.4941, blue: 0, alpha: 1.0)

	static let darkRed: UIColor = UIColor(red: 0.2667, green: 0, blue: 0, alpha: 1.0) /* #440000 */




	// MARK: Defined priorities backgrounds

	static let criticalPriority: UIColor = UIColor.systemRed

	static let highPriority: UIColor = UIColor.systemOrange

	static let mediumPriority: UIColor = UIColor.faintYellow

    static let lowPriority: UIColor = UIColor.systemBlue

	// MARK: Defined text colours
	static let mediumPriorityText: UIColor = UIColor.goldenYellow

}
