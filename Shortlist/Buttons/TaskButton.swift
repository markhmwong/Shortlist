//
//  TaskButton.swift
//  Five
//
//  Created by Mark Wong on 22/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskButton: UIButton {
    
    private struct Constants {
        static let lineWidth: CGFloat = 2.0
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
        
        static let completeColor: UIColor = UIColor.white
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
		let height: CGFloat = 30.0
        let path = UIBezierPath(arcCenter: CGPoint(x: height / 2, y: height / 2), radius: (height / 3) - Constants.lineWidth, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        //fill
        stateColor.setFill()
        path.fill()
        
        //stroke/border
        Constants.borderColor.setStroke()
        path.lineWidth = Constants.lineWidth
        path.stroke()
    }
}
