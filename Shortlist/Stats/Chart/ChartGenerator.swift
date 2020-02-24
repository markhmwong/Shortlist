//
//  BarChartGenerator.swift
//  Five
//
//  Created by Mark Wong on 24/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry
import UIKit

// Generates the bar chart properties such as height, width and position of all the elements in the chart
// from the input data

class ChartGenerator {
    
    private var barWidth: CGFloat = 0
    
    private var padding: CGFloat
    
    private var spacing: CGFloat = 0
    
    private var data: [Day]? // Day data over a specific period of time such as a week / month / year
    
    private var monthlyData: MonthOverviewChartData?
    
    private var barEntries: [BarProperties] = []
    
	private var dotEntries: [DotProperties] = []
	
    private var incompleteBarEntries: [BarProperties] = []
    
    private var topPadding: CGFloat = 5.0
    
    var meanHeight: CGFloat = 0.0
    
    var maxIndicatorHeight: CGFloat = 0.0
    

    init(data: [Day], padding: CGFloat = 15.0) {
        self.data = data
        self.padding = padding
    }
    
    // data - raw data.
    
    init(data: MonthOverviewChartData, padding: CGFloat = 15.0) {
        self.monthlyData = data
        self.padding = padding
    }
    
    // Creates the data needed to display the bar chart.
    // Converts raw data to chart data.
    // Properties such as bar height and text labels
    // viewWidth has taken into account the inner padding on the sides
	
    func generateBarData(viewHeight: CGFloat, viewWidth: CGFloat) -> ([BarProperties], [BarProperties]) {
        
		// monthlyData moniker not representative of purpose
        guard let monthlyData = monthlyData else {
            fatalError("Error: Monthly Data unavailable")
        }
        
		// w - width of 2 bars plus the distance to the next
		let w = ((viewWidth - 20.0) / CGFloat(monthlyData.data.count)) * 0.5
		barWidth = w * 0.5 // halved again because we have 2 bars - completed / incomplete
		spacing = w
		
        let sorted = monthlyData.data.sorted { $0.key < $1.key }
        let barColor: UIColor = UIColor(red:0.36, green:0.94, blue:0.62, alpha:1.0)
        let incompleteColor: UIColor = UIColor(red:0.94, green:0.36, blue:0.44, alpha:1.0)
        
        // key - month, value - day
        // Iterates over the raw data from CoreData to transpose the data to CGPoints/widths/heights
        // of the bar chart.
        for (index, data) in sorted.enumerated() {
            let heightInPercentage: CGFloat = CGFloat(data.value.numberOfCompletedTasks) / CGFloat(monthlyData.maxTasks)
            let incompletePercentage: CGFloat = CGFloat(data.value.incompleteTasks) / CGFloat(monthlyData.maxTasks)
			var xPos: CGFloat = 0.0
            
            if (index == 0) {
                xPos = CGFloat(index) * (2 * barWidth) + spacing
            } else {
                xPos = CGFloat(index) * (2 * barWidth + spacing) + spacing
            }
			
			// heights
            if (heightInPercentage == 0.0) {
                let heightOfBar = (viewHeight - topPadding) * heightInPercentage < 0 ? 0 : (viewHeight - topPadding) * heightInPercentage
				let yPos = (viewHeight) - heightOfBar
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(completeColor: barColor, day: data.value, barWidth: barWidth, barHeight: -1.0, origin: origin)
				
                barEntries.append(barData)
            } else {
                let heightOfBar = (viewHeight - topPadding) * heightInPercentage < 0 ? 0 : (viewHeight - topPadding) * heightInPercentage
                let yPos = (viewHeight) - heightOfBar
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(completeColor: barColor, day: data.value, barWidth: barWidth, barHeight: heightOfBar, origin: origin)
                barEntries.append(barData)
            }
			
			if (incompletePercentage == 0.0) {
                let heightOfIncompleteBar = (viewHeight - topPadding) * incompletePercentage < 0 ? 0 : (viewHeight - topPadding) * incompletePercentage
                let yPosIncomplete = (viewHeight) - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos + barWidth, y: yPosIncomplete)
				let incompleteBarData = BarProperties(completeColor: incompleteColor, day: data.value, barWidth: barWidth, barHeight: -1.0, origin: incompleteOrigin)
                incompleteBarEntries.append(incompleteBarData)
				
			} else {
                let heightOfIncompleteBar = (viewHeight - topPadding) * incompletePercentage < 0 ? 0 : (viewHeight - topPadding) * incompletePercentage
                let yPosIncomplete = (viewHeight) - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos + barWidth, y: yPosIncomplete)
				let incompleteBarData = BarProperties(completeColor: incompleteColor, day: data.value, barWidth: barWidth, barHeight: heightOfIncompleteBar, origin: incompleteOrigin)
                incompleteBarEntries.append(incompleteBarData)
			}
			
        }
        return (barEntries, incompleteBarEntries)
    }
	
	// generates the x y coordinates for the chart data lines
	func generateLineData(viewHeight: CGFloat, viewWidth: CGFloat, padding: CGFloat) -> [DotProperties] {
		// monthlyData moniker not representative of purpose
        guard let monthlyData = monthlyData else {
            fatalError("Error: Monthly Data unavailable")
        }
        
		if (monthlyData.data.count > 0) {
			// The spacing between each point

			let pointSpacing = (viewWidth / CGFloat(monthlyData.data.count - 1))
			spacing = pointSpacing
			
			let sorted = monthlyData.data.sorted { $0.key < $1.key }
			
			// key - month, value - day
			// Iterates over the raw data from CoreData to transpose the data to CGPoints/widths/heights
			// of the bar chart.]
			let initialxPos = padding
			for (index, data) in sorted.enumerated() {

				let xPos: CGFloat = (CGFloat(index) * spacing) + initialxPos
				
				// incompleted tasks points
				let incompletePercentage: CGFloat = CGFloat(data.value.incompleteTasks) / CGFloat(monthlyData.maxTasks)
				let heightOfIncompleteLine = (viewHeight - topPadding) * incompletePercentage < 0 ? 0 : (viewHeight - topPadding) * incompletePercentage
				let incompleteOrigin: CGPoint = CGPoint(x: xPos, y: viewHeight - heightOfIncompleteLine)
				
				// completed tasks points
				let heightInPercentage: CGFloat = CGFloat(data.value.numberOfCompletedTasks) / CGFloat(monthlyData.maxTasks)
				let heightOfLine = (viewHeight - 0) * heightInPercentage < 0 ? 0 : (viewHeight - 0) * heightInPercentage

//				let heightOfLine = (viewHeight - topPadding) * heightInPercentage < 0 ? 0 : (viewHeight - topPadding) * heightInPercentage
				let yPos = (viewHeight) - heightOfLine
				let origin: CGPoint = CGPoint(x: xPos, y: yPos)
				
				// add the DotProperty to an array
				dotEntries.append(DotProperties(completeColor: Theme.Chart.lineTaskCompleteColor, incompleteColor: Theme.Chart.lineTaskIncompleteColor, completedTaskPointOrigin: origin, incompleteTasksPointOrigin: incompleteOrigin, day: data.value))
			}
			return dotEntries
		} else {
			let date = Calendar.current.dayOfWeek(date: Calendar.current.today() as Date)
			let dayDate = Calendar.current.dayDate(date: Calendar.current.today())
            guard let dayOfWeek = DayOfWeek(rawValue: Int16(date)) else {
                fatalError("Day Type does not exist")
            }
			dotEntries.append(DotProperties(completeColor: Theme.Chart.lineTaskCompleteColor, incompleteColor: Theme.Chart.lineTaskIncompleteColor, completedTaskPointOrigin: .zero, incompleteTasksPointOrigin: .zero, day: DayOverview(dayOfWeek: dayOfWeek, dayDate: dayDate, numberOfCompletedTasks: 0, incompleteTasks: 0)))
			return dotEntries
		}
	}
    
    func calculateHeightOfMean(viewHeight: CGFloat) {
        guard let monthlyData = monthlyData else { return }
        let percentage: CGFloat = CGFloat(monthlyData.mean) / CGFloat(monthlyData.maxTasks)
        meanHeight = viewHeight - ((viewHeight - topPadding) * percentage)
    }
    
    func calculateHeightOfMax(viewHeight: CGFloat) {
        maxIndicatorHeight = viewHeight - (viewHeight - topPadding)
    }
}


