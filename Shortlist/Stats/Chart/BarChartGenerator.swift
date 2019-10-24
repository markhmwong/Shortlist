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

class BarChartGenerator {
    
    private var barWidth: CGFloat
    
    private var padding: CGFloat
    
    private let spacing: CGFloat
    
    private var data: [Day]? // Day data over a specific period of time such as a week / month / year
    
    private var monthlyData: MonthOverviewChartData? // rename
    
    private var barEntries: [BarProperties] = []
    
    private var incompleteBarEntries: [BarProperties] = []
    
    private var topPadding: CGFloat = 70.0
    
    var meanHeight: CGFloat = 0.0
    
    var maxIndicatorHeight: CGFloat = 0.0
    
    init(barWidth: CGFloat = 40, spacing: CGFloat = 15.0, data: [Day], padding: CGFloat = 15.0) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.data = data
        self.padding = padding
    }
    
    // data - raw data.
    
    init(barWidth: CGFloat = 40.0, spacing: CGFloat = 10.0, data: MonthOverviewChartData, padding: CGFloat = 15.0) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.monthlyData = data
        self.padding = padding
    }
    
    // Creates the data needed to display the bar chart.
    // Converts raw data to chart data.
    // Properties such as bar height and text labels
    
    func generateBarData(viewHeight: CGFloat, viewWidth: CGFloat) -> ([BarProperties], [BarProperties]) {
        
        // bar width calculation. Possible to inject the width manually. but this overrides the injected value
//        calculateBarWidth(viewWidth: viewWidth)
        
        guard let monthlyData = monthlyData else {
            fatalError("Error: Monthly Data unavailable")
        }
        
        let numberOfBars: CGFloat = CGFloat(monthlyData.data.count) * 2
        barWidth = ((viewWidth - (spacing * CGFloat(monthlyData.data.count))) / numberOfBars)
        let sorted = monthlyData.data.sorted { $0.key < $1.key }
        var totalCompletedTasks: Int16 = 0
        
        let barColor: UIColor = UIColor(red:0.36, green:0.94, blue:0.62, alpha:1.0)
        let incompleteColor: UIColor = UIColor(red:0.94, green:0.36, blue:0.44, alpha:1.0)
        
        // key - month, value - day
        // Iterates over the raw data from CoreData to transpose the data to CGPoints/widths/heights
        // of the bar chart.
        for (index, data) in sorted.enumerated() {
            let heightInPercentage: CGFloat = CGFloat(data.value.numberOfCompletedTasks) / CGFloat(monthlyData.maxTasks)
            let incompletePercentage: CGFloat = CGFloat(data.value.incompleteTasks) / CGFloat(monthlyData.maxTasks)

            totalCompletedTasks += data.value.numberOfCompletedTasks
            var xPos: CGFloat = 0.0
            if (index == 0) {
                xPos = CGFloat(index) * (2 * barWidth) + spacing
            } else {
                xPos = CGFloat(index) * (2 * barWidth + spacing) + spacing
            }

            if (heightInPercentage == 0.0) {
                let heightOfBar = (viewHeight - topPadding) * heightInPercentage < 0 ? 0 : (viewHeight - topPadding) * heightInPercentage
				let yPos = (viewHeight) - heightOfBar
                
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(color: barColor, day: data.value, barWidth: barWidth, barHeight: -1.0, origin: origin)
                barEntries.append(barData)
                
            } else {
                let heightOfBar = (viewHeight - topPadding) * heightInPercentage < 0 ? 0 : (viewHeight - topPadding) * heightInPercentage
                let yPos = (viewHeight) - heightOfBar
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(color: barColor, day: data.value, barWidth: barWidth, barHeight: heightOfBar, origin: origin)
                barEntries.append(barData)
            }
			
			if (incompletePercentage == 0.0) {
                let heightOfIncompleteBar = (viewHeight - topPadding) * incompletePercentage < 0 ? 0 : (viewHeight - topPadding) * incompletePercentage
                let yPosIncomplete = (viewHeight) - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos + barWidth, y: yPosIncomplete)
				let incompleteBarData = BarProperties(color: incompleteColor, day: data.value, barWidth: barWidth, barHeight: -1.0, origin: incompleteOrigin)
                incompleteBarEntries.append(incompleteBarData)
				
			} else {
                let heightOfIncompleteBar = (viewHeight - topPadding) * incompletePercentage < 0 ? 0 : (viewHeight - topPadding) * incompletePercentage
                let yPosIncomplete = (viewHeight) - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos + barWidth, y: yPosIncomplete)
				let incompleteBarData = BarProperties(color: incompleteColor, day: data.value, barWidth: barWidth, barHeight: heightOfIncompleteBar, origin: incompleteOrigin)
                incompleteBarEntries.append(incompleteBarData)
			}
			
        }
        
        // Add extra padding to the chart to pad out the remaining days of the month / week
//        let numberOfDaysInMonth = Calendar.current.daysInMonth()
//        if (numberOfDaysInMonth - sorted.count != 0) {
//            let daysRemaining = numberOfDaysInMonth - sorted.count
//            let barColor: UIColor = UIColor.clear
//            for _ in 0..<daysRemaining {
//                let zeroBar = BarProperties(color: barColor, day: nil, barWidth: barWidth, barHeight: 0.0, origin: .zero)
//                barEntries.append(zeroBar)
//            }
//        }
        
//        for bar in barEntries {
//
//            print(bar.day?.dayDate)
//
//        }
        
        return (barEntries, incompleteBarEntries)
    }
    
    // Screen width varies. We use this function to calculate the width of the bars for various
    // iPhone models
    
    func calculateBarWidth(viewWidth: CGFloat) {
        
        guard let monthlyData = monthlyData else {
            self.barWidth = 0.0
            return
        }
        let numberOfBars: CGFloat = CGFloat(monthlyData.data.count) * 2
        self.barWidth = ((viewWidth) / numberOfBars) - spacing
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

struct BarProperties {
    // Bar Color
    let color: UIColor
    
    // To be changed
    let day: DayOverview?
    
    let barWidth: CGFloat
    
    let barHeight: CGFloat
    
    let origin: CGPoint
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
    
    // To be shown on top of the bar
//    let textValue: String
    
    // To be shown at the bottom of the bar
//    let title: String
}
