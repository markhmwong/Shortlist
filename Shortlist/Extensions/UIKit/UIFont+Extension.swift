//
//  UIFont+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UIFont {

	static var largeTitle: UIFont {
		return UIFont.preferredFont(forTextStyle: .largeTitle)
	}

	static var body: UIFont {
		return UIFont.preferredFont(forTextStyle: .body)
	}

	func with(weight: UIFont.Weight) -> UIFont {
		return UIFont.systemFont(ofSize: pointSize, weight: weight)
	}

}
