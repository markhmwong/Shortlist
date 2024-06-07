//
//  Binding.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

class Binding<T> {
	var value: T {
		didSet {
			listener?(value)
		}
	}
	
	private var listener: ((T) -> Void)?
	
	init(value: T) {
		self.value = value
	}
	
	func bind(_ closure: @escaping (T) -> Void) {
		closure(value)
		listener = closure
	}
}
