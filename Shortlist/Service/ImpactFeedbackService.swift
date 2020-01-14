//
//  ImpactFeedbackService.swift
//  Shortlist
//
//  Created by Mark Wong on 28/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ImpactFeedbackService {
	
	static let shared: ImpactFeedbackService = ImpactFeedbackService()
	
	func impactType(feedBackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: feedBackStyle)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
	}
	
}
