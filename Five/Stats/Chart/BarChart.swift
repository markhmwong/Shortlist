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
    
    // scrollView? might leave this out
    
    // bar chart generator
    private var chartGenerator: BarChartGenerator?
    
    private var monthOverviewChartData: MonthOverviewChartData?
    
//    private var weekOverviewChartData: WeekOverViewChartData?
    
    let padding: CGFloat = 20.0
    
    private var chartData: [BarProperties]? {
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
        print("bar chart - set up view")
        layer.addSublayer(mainLayer)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func prepareChartWithData() {
        // BarChartGenerator
        
        guard let monthlyData = monthOverviewChartData else { return }
        chartGenerator = BarChartGenerator(data: monthlyData)
        chartData = chartGenerator?.generateBarData(viewHeight: bounds.height, viewWidth: bounds.width - padding) //take into account left/right padding
    }
    
    private func drawChart() {
        
        guard let chartData = chartData else { return }
        for (_, bar) in chartData.enumerated() {
             mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.color.cgColor)
        }

        mainLayer.addChartTitleLayer(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0), color: UIColor.white.cgColor, fontSize: 16.0, text: monthOverviewChartData?.title ?? "_month_")
        
        let averageStr: String = "Average:\(monthOverviewChartData!.mean)"
        let width = averageStr.width(withConstrainedHeight: 50.0, font: UIFont.systemFont(ofSize: 16.0))
        mainLayer.addChartTitleLayer(frame: CGRect(x: bounds.width - width - padding, y: 0.0, width: width, height: 50.0), color: UIColor.white.cgColor, fontSize: 16.0, text: averageStr)

        let meanHeight = chartGenerator!.meanHeight
        let meanColor = UIColor(red:0.74, green:0.97, blue:1.00, alpha:0.7)
        mainLayer.addChartMeanLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: meanHeight), endPoint: CGPoint(x: bounds.width - padding, y: meanHeight)), width: 1.0, color: meanColor.cgColor)
        
        mainLayer.backgroundColor = UIColor.gray.cgColor
        mainLayer.cornerRadius = 5.0
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
