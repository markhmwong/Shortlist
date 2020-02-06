//
//  TipsService.swift
//  Shortlist
//
//  Created by Mark Wong on 6/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

class TipsService: NSObject {
	
	static var shared: TipsService = TipsService()
	
	override init() {
		
	}
	
	func randomTip() -> String {
		let randomNum: Int = Int.random(in: 0..<ProductivityTips.tipArray.count)
		return ProductivityTips.tipArray[randomNum]
	}
	
}
