//
//  LineChart.swift
//  Shortlist
//
//  Created by Mark Wong on 2/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LineChart: UIView {
	
	let xAxisFontSize: CGFloat = 12.0
	
	// mainLayer
	private let mainLayer: CALayer = CALayer()
	
	// bar chart generator - generates chart data points in order for it to be drawn
	private var chartGenerator: ChartGenerator?
	
	private var monthOverviewChartData: MonthOverviewChartData?
	
	let innerHoriztonalPadding: CGFloat = 20.0 // chart padding horizontal
	
	let innerHeightPadding: CGFloat = 30.0 // chart padding vertical
	
	let xPadding: CGFloat = 30.0
	
	let meanLineWidth: CGFloat = 2.0
	
	let lineWidth: CGFloat = 2.0
	
	let mainLayerXPadding: CGFloat = 16.0
	
	let chartBackgroundColor: UIColor = Theme.Chart.chartBackgroundColor
	
    // barEntries tuple (completed tasks, incomplete Tasks)
    private var chartData: [DotProperties]? {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
			mainLayer.frame = CGRect(x: mainLayerXPadding / 2, y: 0, width: bounds.width - mainLayerXPadding, height: bounds.height)
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
	
	private func setupView() {
		layer.addSublayer(mainLayer)
        self.translatesAutoresizingMaskIntoConstraints = false
        mainLayer.backgroundColor = chartBackgroundColor.cgColor
        mainLayer.cornerRadius = 5.0
	}
	
    func prepareChartWithData() {
        guard let monthlyData = monthOverviewChartData else { return }
        chartGenerator = ChartGenerator(data: monthlyData, padding: innerHoriztonalPadding)
		
		chartData = chartGenerator?.generateLineData(viewHeight: bounds.height - innerHeightPadding, viewWidth: bounds.width - (innerHoriztonalPadding * 2), padding: innerHoriztonalPadding)
    }
	
	private func drawChart() {
		guard let _chartData = chartData else { return }
		
		let (linePath, incompleteLinePath) = createLineFromPoints(_chartData)
		
		// draw the chart data lines
		drawLine(path: incompleteLinePath.cgPath, color: Theme.Chart.lineTaskIncompleteColor)
		drawLine(path:  linePath.cgPath, color: Theme.Chart.lineTaskCompleteColor)
		
		// draw the average indicator line if it isn't 0
		if (monthOverviewChartData!.mean != 0) {
			// add mean number indicator
			let meanHeight: CGFloat = chartGenerator!.meanHeight
			let meanNumberStr: NSString = "\(monthOverviewChartData!.mean)" as NSString
			let meanSizeStr = meanNumberStr.size(withAttributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
			let meanFrame: CGRect = CGRect(x: frame.width - xPadding - meanSizeStr.width, y: meanHeight, width: meanSizeStr.width, height: meanSizeStr.height)
			
			// average indicator
			mainLayer.addChartTitleLayer(frame: meanFrame, color: Theme.Font.DefaultColor.cgColor, fontSize: Theme.Font.FontSize.Standard(.b3).value, text: meanNumberStr as String)

			// mean height indicator. We add this after the bars are added to the view, so that the line covers the bottom of the bars
//			mainLayer.addChartLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: meanHeight), endPoint: CGPoint(x: bounds.width - xPadding, y: meanHeight)), width: meanLineWidth, color: Theme.Chart.meanLineColor.cgColor)
		}
		
//		let maxIndicatorHeight: CGFloat = chartGenerator!.maxIndicatorHeight

		// max line indicator
//		mainLayer.addChartLine(lineSegement: LineSegment(startPoint: CGPoint(x: 5.0, y: maxIndicatorHeight), endPoint: CGPoint(x: bounds.width - xPadding, y: maxIndicatorHeight)), width: lineWidth, color: Theme.Chart.chartLineColor.cgColor)

        // include max number indicator
        let maxIndicatorNumberStr: NSString = "\(monthOverviewChartData!.maxTasks)" as NSString
		let sizeStr = maxIndicatorNumberStr.size(withAttributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b5).value)!])
		let maxFrame: CGRect = CGRect(x: frame.width - xPadding - sizeStr.width, y: 10.0, width: sizeStr.width, height: sizeStr.height)
		
		mainLayer.addChartTitleLayer(frame: maxFrame, color: Theme.Chart.chartTitleColor.cgColor, fontSize: Theme.Font.FontSize.Standard(.b5).value, text: maxIndicatorNumberStr as String)
		
		// middle indicators
		// to fix when clearing data it causes an error here
//		for i in stride(from: 0, through: monthOverviewChartData!.maxTasks, by: Int(monthOverviewChartData!.maxTasks / 3)) {
//
//			let middleIndicator: CGFloat = bounds.height - ((bounds.height - maxIndicatorHeight) / CGFloat(monthOverviewChartData!.maxTasks)) * CGFloat(i)
//
//			mainLayer.addChartGuides(lineSegement: LineSegment(startPoint: CGPoint(x: 15.0, y: middleIndicator), endPoint: CGPoint(x: bounds.width - xPadding, y: middleIndicator)), width: lineWidth, color: Theme.Chart.chartLineColor.adjust(by: -70.0)!.cgColor)
//		}
		
        // add chart title
		let chartFont = UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!
        let charTitleStr = "\(monthOverviewChartData?.title ?? "chartTitle")"
		let titleWidth = charTitleStr.width(withConstrainedHeight: 50.0, font: chartFont)
        let titleFrame: CGRect = CGRect(x: xPadding, y: 10.0, width: titleWidth, height: 20.0)
		
        mainLayer.addChartTitleLayer(frame: titleFrame, color: Theme.Chart.chartTitleColor.cgColor, fontSize: 16.0, text: monthOverviewChartData?.title ?? "_month_")
		
        // add average stat
        let averageStr: String = "Average \(monthOverviewChartData!.mean)"
        let width = averageStr.width(withConstrainedHeight: 20.0, font: chartFont)
        let averageFrame = CGRect(x: titleFrame.minX, y: titleFrame.maxY + 5.0, width: width, height: 20.0)
		
        mainLayer.addChartTitleLayer(frame: averageFrame, color: Theme.Chart.chartTitleColor.cgColor, fontSize: xAxisFontSize, text: averageStr)
	}
	
	//add to stats as text for quick reference as graphs show performance over time, total tasks, total complete tasks, total incomplete tasks
	// returns a tuple (completepath, incompletepath)
	func createLineFromPoints(_ chartData: [DotProperties]) -> (UIBezierPath, UIBezierPath) {
		
		// the height where the y axis is 0 - bottom of the graph
		// I use this to draw the straight line at the bottom of the graph, as it seems the curved algorithm won't connect the lines together
		let zeroHeight = bounds.maxY
		
		let curvedPathComplete = UIBezierPath()
		let curvedPathIncomplete = UIBezierPath()
		
		var completePoints: [CGPoint] = []
		var incompletePoints: [CGPoint] = []
		
		for (_, data) in chartData.enumerated() {
			let adjustedComplete: CGPoint = CGPoint(x: data.completedTaskPointOrigin.x - innerHoriztonalPadding / 2, y: data.completedTaskPointOrigin.y + 10)
			let adjustedIncomplete: CGPoint = CGPoint(x: data.incompleteTasksPointOrigin.x - innerHoriztonalPadding / 2, y: data.incompleteTasksPointOrigin.y + 10)
			completePoints.append(adjustedComplete)
			incompletePoints.append(adjustedIncomplete)
		}
		
		let curvedSegA = controlPointsFrom(points: completePoints)
		let curvedSegB = controlPointsFrom(points: incompletePoints)
		
		// move to the beginning (starting from the left
		curvedPathComplete.move(to: completePoints[0])
		curvedPathIncomplete.move(to: incompletePoints[0])
		
		var prevPoint: CGPoint = .zero
		var prevPointIncomplete: CGPoint = .zero
		for i in 1..<completePoints.count {
			
			// the next two if conditions are dedicated to draw the straight lines at the 0 y points
			// we check for equality if the y points are the same, which means we need to draw a straight line but we only need the straight line at the bottom of the graph not at the top, which is why the zeroHeight variable is needed to ensure we are at the bottom of the graph
			if (i > 1) {
				prevPoint = completePoints[i-1]
				
				if prevPoint.y == completePoints[i].y && zeroHeight == completePoints[i].y {
					curvedPathComplete.addLine(to: completePoints[i])
				} else {
					curvedPathComplete.addCurve(to: completePoints[i], controlPoint1: curvedSegA[i-1].controlPoint1, controlPoint2: curvedSegA[i-1].controlPoint2)
				}
			} else {
				curvedPathComplete.addCurve(to: completePoints[i], controlPoint1: curvedSegA[i-1].controlPoint1, controlPoint2: curvedSegA[i-1].controlPoint2)
			}
			
			if (i > 1) {
				prevPointIncomplete = incompletePoints[i-1]
				
				if prevPointIncomplete.y == incompletePoints[i].y && zeroHeight == incompletePoints[i].y {
					curvedPathIncomplete.addLine(to: incompletePoints[i])
				} else {
					curvedPathIncomplete.addCurve(to: incompletePoints[i], controlPoint1: curvedSegB[i-1].controlPoint1, controlPoint2: curvedSegB[i-1].controlPoint2)
				}
			} else {
				curvedPathIncomplete.addCurve(to: incompletePoints[i], controlPoint1: curvedSegB[i-1].controlPoint1, controlPoint2: curvedSegB[i-1].controlPoint2)
			}

		}

		for (_, data) in chartData.enumerated() {
			let incompletePoint: CGPoint = CGPoint(x: data.incompleteTasksPointOrigin.x, y: data.incompleteTasksPointOrigin.y - 10)
			let completePoint: CGPoint = CGPoint(x: data.incompleteTasksPointOrigin.x, y: data.incompleteTasksPointOrigin.y - 10)
//			drawDot(point: incompletePoint, color: Theme.Chart.lineTaskIncompleteColor)
//			drawDot(point: completePoint, color: Theme.Chart.lineTaskCompleteColor)
			drawDot(point: incompletePoint, color: .clear)
			drawDot(point: completePoint, color: .clear)
		}
		return (curvedPathComplete, curvedPathIncomplete)
	}
	
	// chart lateral indicator lines
	private func drawLine(path: CGPath, color: UIColor) {
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path
		shapeLayer.strokeColor = color.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineWidth = 3.0
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

//		gradientLayer.colors = [color.adjust(by: -40.0)!.cgColor, color.cgColor]
		gradientLayer.colors = [UIColor.purple.cgColor, color.cgColor]
		gradientLayer.frame = bounds
		gradientLayer.mask = shapeLayer

		mainLayer.insertSublayer(gradientLayer, at: 1)
	}
	
	private func drawDot(point: CGPoint, color: UIColor) {
		let pointSize: CGFloat = 0.1
		let circlePath = UIBezierPath(arcCenter: point, radius: pointSize, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
		let shapeLayer = CAShapeLayer()
			shapeLayer.path = circlePath.cgPath
		shapeLayer.strokeColor = color.cgColor
		shapeLayer.fillColor = color.cgColor
		shapeLayer.lineWidth = 3.0
		layer.addSublayer(shapeLayer)
	}
	
	// reference https://medium.com/@leonardnguyen/building-your-own-chart-in-ios-part-2-line-chart-7b5cfc7c866
	private func controlPointsFrom(points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []
        
        let delta: CGFloat = 0.3 // The value that help to choose temporary control points.
        
        // Calculate temporary control points, these control points make Bezier segments look straight and not curving at all
        for i in 1..<points.count {
            let A = points[i-1]
            let B = points[i]
            let controlPoint1 = CGPoint(x: A.x + delta*(B.x-A.x), y: A.y + delta*(B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta*(B.x-A.x), y: B.y - delta*(B.y - A.y))
            let curvedSegment = CurvedSegment(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }
        
        // Calculate good control points
        for i in 1..<points.count-1 {
            /// A temporary control point
            let M = result[i-1].controlPoint2
            
            /// A temporary control point
            let N = result[i].controlPoint1
            
            /// central point
            let A = points[i]
            
            /// Reflection of M over the point A
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)
            
            /// Reflection of N over the point A
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)
            
            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x)/2, y: (MM.y + N.y)/2)
            result[i-1].controlPoint2 = CGPoint(x: (NN.x + M.x)/2, y: (NN.y + M.y)/2)
        }
        
        return result
    }
}
