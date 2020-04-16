//
//  ReminderError.swift
//  Shortlist
//
//  Created by Mark Wong on 8/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

enum ReminderError: Int, ErrorProtocol, CaseIterable {
		
	case exists = 0
	case sameTask
	case duplicate
	case alreadyDone
	case noPass
	case noTouch
	case beNice
	case tipMe
	case pathToTip
	case binary
	case randomMovie
	
	public var localizedDescription: String {
		switch self {
			case .exists:
				return "this task already exists in Today's list!"
			case .sameTask:
				return "do you really want to do the same task twice?"
			case .duplicate:
				return "duplicate found"
			case .alreadyDone:
				return "you may have done this already"
			case .noPass:
				return "you shall not pass."
			case .noTouch:
				return "stop touching me."
			case .beNice:
				return "be nice."
			case .tipMe:
				return "I may ask you to tip me.."
			case .pathToTip:
				return "Settings -> Tip"
			case .binary:
				return "01001110 01101111"
			case .randomMovie:
				return "I can't believe they're making Matrix 4."
		}
	}
}

