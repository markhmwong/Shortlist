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
	
	lazy var button: ProgressBarContainer = {
		let button = ProgressBarContainer()
		button.isUserInteractionEnabled = false
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
        
    var taskState: Bool = false {
        didSet {
            //update color
			ImpactFeedbackService.shared.impactType(feedBackStyle: .light)
            if (taskState) {
                //fill
				DispatchQueue.main.async {
					self.button.changeColor(Theme.Cell.taskCompleteColor)
					self.button.updateProgressBar(1.0)
					self.button.changeWidth(7.0)
				}

            } else {
				DispatchQueue.main.async {
					self.button.changeColor(Theme.Cell.taskCompleteColor)
					self.button.updateProgressBar(0.0)
					self.button.changeWidth(7.0)
				}
            }
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
	
	init(frame: CGRect, barWidth: CGFloat) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	func setupButton() {
		addSubview(button)
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()

		button.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: CGSize(width: halfWidth, height: halfWidth))
	}
	
}
