//
//  ChartView.swift
//  Five
//
//  Created by Mark Wong on 24/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
// not in use currently
class BarChart: UIView {
    
    // mainLayer
    private let mainLayer: CALayer = CALayer()
    
    // bar chart generator - generates chart data points in order for it to be drawn
    private var chartGenerator: ChartGenerator?
    
    private var monthOverviewChartData: MonthOverviewChartData?
    
//    private var weekOverviewChartData: WeekOverViewChartData?
    
    let innerChartPadding: CGFloat = 40.0
    
    let xPadding: CGFloat = 20.0
    
    let meanLineWidth: CGFloat = 2.0
    
    let chartBackgroundColor: UIColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
    
    // barEntries tuple (completed tasks, incomplete Tasks)
    private var chartData: ([BarProperties], [BarProperties])? {
        didSet {
			let xPadding: CGFloat = 8.0
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            mainLayer.frame = CGRect(x: xPadding, y: 10, width: bounds.width - (xPadding * 2), height: bounds.height)
            chartGenerator?.calculateHeightOfMean(viewHeight: mainLayer.frame.height)
            chartGenerator?.calculateHeightOfMax(viewHeight: mainLayer.frame.height)
            drawChart()
        }
    }
    
    init(inputData: MonthOverviewChartData) {
        self.monthOverviewChartData = inputData
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        layer.addSublayer(mainLayer)
        self.translatesAutoresizingMaskIntoConstraints = false
        mainLayer.backgroundColor = chartBackgroundColor.cgColor
        mainLayer.cornerRadius = 5.0
    }
    
    func prepareChartWithData() {
        // BarChartGenerator
        
        guard let monthlyData = monthOverviewChartData else { return }
        chartGenerator = ChartGenerator(data: monthlyData, padding: innerChartPadding)
        chartData = chartGenerator?.generateBarData(viewHeight: bounds.height, viewWidth: bounds.width - innerChartPadding) //take into account left/right padding
    }
    
    private func drawChart() {
        guard let (chartData, incompleteTaskChartData) = chartData else { return }
        let maxIndicatorHeight = chartGenerator!.maxIndicatorHeight
        let meanHeight = chartGenerator!.meanHeight
        let lineColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
        
        // add chart title
        let charTitleStr = "\(monthOverviewChartData?.title ?? "chartTitle")"
        let titleWidth = charTitleStr.width(withConstrainedHeight: 50.0, font: UIFont.systemFont(ofSize: 16.0))
        let titleFrame: CGRect = CGRect(x: xPadding, y: 0.0, width: titleWidth, height: 20.0)
        mainLayer.addChartTitleLayer(frame: titleFrame, color: UIColor.white.cgColor, fontSize: 16.0, text: monthOverviewChartData?.title ?? "_month_")
        
        // add average stat
        let averageStr: String = "Daily Average \(monthOverviewChartData!.mean)"
        let width = averageStr.width(withConstrainedHeight: 20.0, font: UIFont.systemFont(ofSize: 16.0))
        let averageFrame = CGRect(x: titleFrame.minX, y: titleFrame.maxY + 5.0, width: width, height: 20.0)
        mainLayer.addChartTitleLayer(frame: averageFrame, color: UIColor.white.cgColor, fontSize: 12.0, text: averageStr)
        
        // draw bars for incomplete tasks
        for (_, bar) in incompleteTaskChartData.enumerated() {
            mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.completeColor)
        }
        
        // draw bars for complete tasks
        for (_, bar) in chartData.enumerated() {
            mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.completeColor)
            let xAxisLabelFrame: CGRect = CGRect(x: bar.barFrame.minX, y: bar.barFrame.maxY, width: bar.barFrame.width * 2, height: 25.0)
            
			// x axis labels
            let day = bar.day!.dayOfWeek.shortHand
            mainLayer.xAxisLabels(frame: xAxisLabelFrame, color: UIColor.white.cgColor, fontSize: 12.0, text: "\(day)")
        }
        
        // include max number indicator
        let maxIndicatorNumberStr: NSString = "\(monthOverviewChartData!.maxTasks)" as NSString
        let sizeStr = maxIndicatorNumberStr.size(withAttributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
        let maxFrame: CGRect = CGRect(x: frame.width - xPadding - sizeStr.width, y: maxIndicatorHeight, width: sizeStr.width, height: sizeStr.height)
        mainLayer.addChartTitleLayer(frame: maxFrame, color: UIColor.white.cgColor, fontSize: Theme.Font.FontSize.Standard(.b3).value, text: maxIndicatorNumberStr as String)
        
        // add mean number indicator
        let meanNumberStr: NSString = "\(monthOverviewChartData!.mean)" as NSString
        let meanSizeStr = meanNumberStr.size(withAttributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
        let meanFrame: CGRect = CGRect(x: frame.width - xPadding - meanSizeStr.width, y: meanHeight, width: meanSizeStr.width, height: meanSizeStr.height)
        mainLayer.addChartTitleLayer(frame: meanFrame, color: UIColor.white.cgColor, fontSize: Theme.Font.FontSize.Standard(.b3).value, text: meanNumberStr as String)
		
		// bottom line indicator. We add this after the bars are added to the view, so that the line covers the bottom of the bars
		mainLayer.addChartLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: meanHeight), endPoint: CGPoint(x: bounds.width - xPadding, y: meanHeight)), width: meanLineWidth, color: lineColor.cgColor)

		// max line indicator
        mainLayer.addChartLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: maxIndicatorHeight), endPoint: CGPoint(x: bounds.width - xPadding, y: maxIndicatorHeight)), width: meanLineWidth, color: lineColor.cgColor)
    }
}

