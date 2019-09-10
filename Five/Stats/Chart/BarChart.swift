//
//  ChartView.swift
//  Five
//
//  Created by Mark Wong on 24/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class BarChart: UIView {
    
    // mainLayer
    private let mainLayer: CALayer = CALayer()
    
    // bar chart generator - generates chart data points in order for it to be drawn
    private var chartGenerator: BarChartGenerator?
    
    private var monthOverviewChartData: MonthOverviewChartData?
    
//    private var weekOverviewChartData: WeekOverViewChartData?
    
    let innerBarPadding: CGFloat = 40.0
    
    let titlePadding: CGFloat = 20.0
    
    let meanLineWidth: CGFloat = 2.0
    
    // barEntries tuple (completed tasks, incomplete Tasks)
    private var chartData: ([BarProperties], [BarProperties])? {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            mainLayer.frame = CGRect(x: 8, y: 10, width: bounds.width - 16.0, height: bounds.height)
            chartGenerator?.calculateHeightOfMean(viewHeight: bounds.height)
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
        
        mainLayer.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:0.6).cgColor
        mainLayer.cornerRadius = 5.0
    }
    
    func prepareChartWithData() {
        // BarChartGenerator
        
        guard let monthlyData = monthOverviewChartData else { return }
        chartGenerator = BarChartGenerator(data: monthlyData, padding: innerBarPadding)
        chartData = chartGenerator?.generateBarData(viewHeight: bounds.height, viewWidth: bounds.width - innerBarPadding) //take into account left/right padding
    }
    
    private func drawChart() {

        guard let (chartData, incompleteTaskChartData) = chartData else { return }
        
        // draw bars for incomplete tasks
        for (_, bar) in incompleteTaskChartData.enumerated() {
            mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.color.cgColor)
        }
        
        // draw bars for complete tasks
        for (_, bar) in chartData.enumerated() {
             mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.color.cgColor)
        }
        
        // add mean line indicator
        let meanHeight = chartGenerator!.meanHeight
        let meanColor = UIColor(red:0.74, green:0.97, blue:1.00, alpha:0.7)
        mainLayer.addChartMeanLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: meanHeight), endPoint: CGPoint(x: bounds.width - titlePadding, y: meanHeight)), width: meanLineWidth, color: meanColor.cgColor)

        // add chart title
        let charTitleStr = "\(monthOverviewChartData?.title ?? "chartTitle")"
        let titleWidth = charTitleStr.width(withConstrainedHeight: 50.0, font: UIFont.systemFont(ofSize: 16.0))
        mainLayer.addChartTitleLayer(frame: CGRect(x: titlePadding, y: 0.0, width: titleWidth, height: 20.0), color: UIColor.white.cgColor, fontSize: 16.0, text: monthOverviewChartData?.title ?? "_month_")
        
        // add average stat
        let averageStr: String = "Average:\(monthOverviewChartData!.mean)"
        let width = averageStr.width(withConstrainedHeight: 20.0, font: UIFont.systemFont(ofSize: 16.0))
        mainLayer.addChartTitleLayer(frame: CGRect(x: mainLayer.bounds.width - width - titlePadding, y: 0.0, width: width, height: 50.0), color: UIColor.white.cgColor, fontSize: 16.0, text: averageStr)
    }
}

