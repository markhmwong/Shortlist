//
//  BarProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 2/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol ChartElement {
	var completeColor: UIColor { get }
	var incompleteColor: UIColor { get }
}

struct BarProperties {
    // Bar Color
    let completeColor: UIColor
    
	// Provides the day on the axis
    let day: DayOverview?
    
    let barWidth: CGFloat
    
    let barHeight: CGFloat
    
    let origin: CGPoint
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

struct DotProperties: ChartElement {
	
	let completeColor: UIColor
	
	let incompleteColor: UIColor
	
	let completedTaskPointOrigin: CGPoint
	
	let incompleteTasksPointOrigin: CGPoint
	
	let day: DayOverview?
}
