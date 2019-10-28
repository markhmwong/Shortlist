//
//  ProgressBarContainer.swift
//  Shortlist
//
//  Created by Mark Wong on 25/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ProgressBarContainer: UIView {
	
	var progressBar: CircularProgressBar?
	
	var progressBarTrack: CircularProgressBar?
	
	init() {
		super.init(frame: .zero)
		self.setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		progressBar = CircularProgressBar()
		progressBarTrack = CircularProgressBar()
		progressBarTrack?.strokeColor = UIColor.black.adjust(by: 20.0)!.cgColor
		
		layer.addSublayer(progressBarTrack!)
		layer.addSublayer(progressBar!)

		backgroundColor = UIColor.clear
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let progressBar = progressBar else { return }
		guard let progressBarTrack = progressBarTrack else { return }

		progressBar.path = UIBezierPath(arcCenter: .zero, radius: bounds.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
		progressBar.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 2.0)
		progressBar.strokeEnd = 0.0
		
		progressBarTrack.path = UIBezierPath(arcCenter: .zero, radius: bounds.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
		progressBarTrack.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 2.0)
		progressBarTrack.strokeEnd = 1.0
	}
	
	func updateProgressBar(_ percentage: CGFloat) {
		guard let progressBar = progressBar else { return }
		progressBar.strokeEnd = percentage
	}
}