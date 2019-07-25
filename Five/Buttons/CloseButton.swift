//
//  CloseButton.swift
//  Five
//
//  Created by Mark Wong on 24/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CloseButton: UIButton {
    private struct Constants {
        static let lineWidth: CGFloat = 3.0
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
        
        static let completeColor: UIColor = UIColor(red:0.78, green:0.76, blue:0.13, alpha:1.0)
        static let incompleteColor: UIColor = UIColor.clear
        static let borderColor: UIColor = UIColor.white
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    var stateColor: UIColor = .clear
    
    var taskState: Bool = false {
        didSet {
            //update color
            if (taskState) {
                //fill
                stateColor = Constants.completeColor
            } else {
                stateColor = Constants.incompleteColor
            }
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        //        layer.cornerRadius = 10.0
    }
    
    override func draw(_ rect: CGRect) {
        //set up the width and height variables
        //for the horizontal stroke
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: (rect.height / 1.5) - Constants.lineWidth, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        //fill
        stateColor.setFill()
        path.fill()
        
        //stroke/border
        Constants.borderColor.setStroke()
        path.lineWidth = Constants.lineWidth
        path.stroke()
        
//        let context = UIGraphicsGetCurrentContext()
//        context?.setStrokeColor(UIColor.white.cgColor)
//        context?.setLineWidth(4.0)
//
//        context?.move(to: CGPoint(x: rect.width / 2, y: path.bounds.origin.y + 5))
//        context?.addLine(to: CGPoint(x: rect.width / 2, y: path.bounds.height - 5))
//        context?.rotate(by: 45.0)
//        context?.drawPath(using: .stroke)
        
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //Vertical Line
        
        plusPath.move(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight - halfPlusWidth + Constants.halfPointShift))
        
        plusPath.addLine(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        //existing code
        //set the stroke color
        UIColor.white.setStroke()
        
//        plusPath.rotateAroundCenter(angle: 90.0)
        plusPath.stroke()

    }
}

//extension UIBezierPath
//{
//    func rotateAroundCenter(angle: CGFloat)
//    {
//        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
//        var transform = CGAffineTransform.identity
//        transform = transform.translatedBy(x: center.x, y: center.y)
//        transform = transform.rotated(by: angle)
//        transform = transform.translatedBy(x: -center.x, y: -center.y)
//        self.apply(transform)
//    }
//}
