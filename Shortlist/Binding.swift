//
//  Binding.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

//https://medium.com/@onmyway133/a-taste-of-mvvm-and-reactive-paradigm-5288a819cca1
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
