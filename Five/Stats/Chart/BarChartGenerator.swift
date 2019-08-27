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
    
    private let spacing: CGFloat
    
    private var data: [Day]? // Day data over a specific period of time such as a week / month / year
    
    private var monthlyData: MonthOverviewChartData?
    
    private var barEntries: [BarProperties] = []
    
    init(barWidth: CGFloat = 40, spacing: CGFloat = 20, data: [Day]) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.data = data
    }
    
    // data - raw data.
    
    init(barWidth: CGFloat = 40.0, spacing: CGFloat = 10.0, data: MonthOverviewChartData) {
        self.barWidth = barWidth
        self.spacing = spacing
        self.monthlyData = data
    }
    
    // Creates the data needed to display the bar chart.
    // Converts raw data to chart data.
    // Properties such as bar height and text labels
    
    func generateBarData(viewHeight: CGFloat, viewWidth: CGFloat) -> [BarProperties] {
        calculateBarWidth(viewWidth: viewWidth)
        guard let monthlyData = monthlyData else {
            fatalError("Error: Monthly Data unavailable")
        }
        
        let data = monthlyData.data
        let sorted = data.sorted { $0.key < $1.key }
        // key - month, value - day
        for (day, data) in sorted {
            // 0 - 1
            let heightInPercentage: CGFloat = CGFloat(data.numberOfCompletedTasks) / CGFloat(monthlyData.maxTasks)
            let barColor: UIColor = UIColor.orange
            
            
            if (heightInPercentage == 0.0) {
                let barData = BarProperties(color: barColor, day: data, barWidth: barWidth, barHeight: 0.0, origin: .zero)
                barEntries.append(barData)
            } else {
                let xPos = CGFloat(day) * (barWidth + spacing)
                let topPadding: CGFloat = 10.0
                let heightOfBar = viewHeight * heightInPercentage - topPadding
                let yPos = viewHeight - heightOfBar
                let origin: CGPoint = CGPoint(x: xPos, y: yPos)
                let barData = BarProperties(color: barColor, day: data, barWidth: barWidth, barHeight: heightOfBar, origin: origin)
                barEntries.append(barData)
            }
        }
        
        for bar in barEntries {
            print(bar.day.dayDate)
        }
        
        return barEntries
    }
    
    // Screen width varies. We use this function to calculate the width of the bars for various
    // iPhone models
    
    func calculateBarWidth(viewWidth: CGFloat) {
        guard let monthlyData = monthlyData else {
            barWidth = 10.0
            return
        }
        let numberOfBars = CGFloat(monthlyData.data.count)
        self.barWidth = (viewWidth / numberOfBars) - spacing
    }
}

struct BarProperties {
    // Bar Color
    let color: UIColor
    
    // To be changed
    let day: DayOverview
    
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
