//
//  Bool+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 12/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

extension Bool {
	static func ^ (left: Bool, right: Bool) -> Bool {
		return left != right
	}
}
