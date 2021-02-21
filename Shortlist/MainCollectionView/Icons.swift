//
//  Icons.swift
//  Shortlist
//
//  Created by Mark Wong on 25/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

/*****
		SF Symbol icons to be used across the application
******/
enum Icons {
	
	case notes
	case redact
	case photo
	case taskName
	case reminder
	case delete
	case noteNumber
	case category
	case priority
	
	var sfSymbolString: String {
		switch self {
			case .notes:
				return "note.text.badge.plus"
			case .redact:
				return "eye.slash.fill"
			case .reminder:
				return "deskclock.fill"
			case .taskName:
				return "pencil.circle.fill"
			case .photo:
				return "photo.fill"
			case .delete:
				return "xmark.bin.fill"
			case .priority:
				return "exclamationmark.circle"
			case .noteNumber:
				return ".circle.fill" // will need to be compelted with a number
			case .category:
				return "square.stack.3d.down.forward.fill"
		}
	}
}
