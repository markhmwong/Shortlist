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
    private let chartGenerator: BarChartGenerator = BarChartGenerator(barWidth: 40, spacing: 20, data: [])
    
    private var monthOverviewChartData: MonthOverviewChartData?
    
//    private var weekOverviewChartData: WeekOverViewChartData?
    
    private var chartData: [BarProperties]? {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            mainLayer.frame = CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height)
            guard let chartData = chartData else { return }
            for (index, entry) in chartData.enumerated() {
                drawBar(index: index, bar: entry)
            }
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
        let chartGenerator = BarChartGenerator(barWidth: 40, spacing: 5, data: monthlyData)
        chartData = chartGenerator.generateBarData(viewHeight: bounds.height, viewWidth: bounds.width)
    }
    
    private func drawBar(index: Int, bar: BarProperties) {
        mainLayer.addRectangleLayer(frame: bar.barFrame, color: bar.color.cgColor)
        
        mainLayer.addChartTitleLayer(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0), color: UIColor.white.cgColor, fontSize: 16.0, text: monthOverviewChartData?.title ?? "_month_")
        
//        let cgColor = entry.color.cgColor
        
        // Show the main bar
        

        // Show an Int value above the bar
//        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, fontSize: 14, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)
        
        // Show a title below the bar
//        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 14, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
    }
    
}
