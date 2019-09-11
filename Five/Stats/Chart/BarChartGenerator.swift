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
    
    private var monthlyData: MonthOverviewChartData?
    
    private var barEntries: [BarProperties] = []
    
    private var incompleteBarEntries: [BarProperties] = []
    
    var meanHeight: CGFloat = 0
    
    init(barWidth: CGFloat = 40, spacing: CGFloat = 15.0, data: [Day], padding: CGFloat = 15.0) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.data = data
        self.padding = padding / 2.0
    }
    
    // data - raw data.
    
    init(barWidth: CGFloat = 40.0, spacing: CGFloat = 10.0, data: MonthOverviewChartData, padding: CGFloat = 15.0) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.monthlyData = data
        self.padding = padding / 2.0
    }
    
    // Creates the data needed to display the bar chart.
    // Converts raw data to chart data.
    // Properties such as bar height and text labels
    
    func generateBarData(viewHeight: CGFloat, viewWidth: CGFloat) -> ([BarProperties], [BarProperties]) {
        
        // bar width calculation. Possible to inject the width manually. but this overrides the injected value
        calculateBarWidth(viewWidth: viewWidth)
        
        guard let monthlyData = monthlyData else {
            fatalError("Error: Monthly Data unavailable")
        }
        
        let sorted = monthlyData.data.sorted { $0.key < $1.key }
        var totalCompletedTasks: Int16 = 0
        let barColor: UIColor = UIColor(red:0.31, green:0.85, blue:0.40, alpha:1.0)
        let incompleteColor: UIColor = UIColor(red:0.83, green:0.22, blue:0.22, alpha:0.8)
        
        // key - month, value - day
        // Iterates over the raw data from CoreData to transpose the data to CGPoints/widths/heights
        // of the bar chart.
        for (index, data) in sorted.enumerated() {
            let heightInPercentage: CGFloat = CGFloat(data.value.numberOfCompletedTasks) / CGFloat(monthlyData.maxTasks)
            let incompletePercentage: CGFloat = CGFloat(data.value.incompleteTasks) / CGFloat(monthlyData.maxTasks)

            totalCompletedTasks += data.value.numberOfCompletedTasks
            
            if (heightInPercentage == 0.0) {
                let barData = BarProperties(color: barColor, day: nil, barWidth: barWidth, barHeight: 0.0, origin: .zero)
                barEntries.append(barData)
                
                let xPos = CGFloat(index) * (barWidth + spacing) + padding //(change to padding)
                let topPadding: CGFloat = 0.0
                let heightOfIncompleteBar = viewHeight * incompletePercentage - topPadding
                let yPosIncomplete = viewHeight - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos - 3.0, y: yPosIncomplete)
                let incompleteBar = BarProperties(color: incompleteColor, day: data.value, barWidth: barWidth, barHeight: heightOfIncompleteBar, origin: incompleteOrigin)
                incompleteBarEntries.append(incompleteBar)
                
            } else {
                let xPos = CGFloat(index) * (barWidth + spacing) + padding //(change to padding)
                let topPadding: CGFloat = 40.0
                let heightOfBar = viewHeight * heightInPercentage - topPadding < 0 ? 0 : viewHeight * heightInPercentage - topPadding
                let yPos = viewHeight - heightOfBar
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(color: barColor, day: data.value, barWidth: barWidth, barHeight: heightOfBar, origin: origin)
                barEntries.append(barData)
                
                let heightOfIncompleteBar = viewHeight * incompletePercentage - topPadding < 0 ? 0 : viewHeight * incompletePercentage - topPadding
                let yPosIncomplete = viewHeight - heightOfIncompleteBar
                let incompleteOrigin = CGPoint(x: xPos - 3.0, y: yPosIncomplete)
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
            return }
        
        let numberOfBars: CGFloat = CGFloat(monthlyData.data.count)
        self.barWidth = ((viewWidth) / numberOfBars) - spacing
    }
    
    func calculateHeightOfMean(viewHeight: CGFloat) {
        guard let monthlyData = monthlyData else { return }
        let mean: CGFloat = CGFloat(monthlyData.mean) / CGFloat(monthlyData.maxTasks)
        meanHeight = viewHeight - (viewHeight * mean - 10.0)
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
