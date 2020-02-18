//
//  ProgressBarContainer.swift
//  Shortlist
//
//  Created by Mark Wong on 25/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ProgressBarContainer: UIView {
	
	struct StatusColor {
		static var high: UIColor = UIColor(red:0.99, green:0.00, blue:0.47, alpha:1.0).adjust(by: -10.0)!
		static var medium: UIColor = UIColor(red:0.99, green:0.77, blue:0.00, alpha:1.0).adjust(by: -10.0)!
		static var low: UIColor = UIColor(red:0.00, green:0.93, blue:0.99, alpha:1.0).adjust(by: -10.0)!
		static var normal: UIColor = UIColor.white
	}
	
	private var progressBar: CircularProgressBar?
	
	private var progressBarTrack: CircularProgressBar?
	
	init() {
		super.init(frame: .zero)
		self.setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		backgroundColor = UIColor.clear
		progressBar = CircularProgressBar()
		progressBarTrack = CircularProgressBar()
		progressBarTrack?.strokeColor = UIColor.black.adjust(by: 20.0)!.cgColor
		guard let _progressBar = progressBar else { return }
		guard let _progressBarTrack = progressBarTrack else { return }
		
		layer.addSublayer(_progressBarTrack)
		layer.addSublayer(_progressBar)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let _progressBar = progressBar else { return }
		guard let _progressBarTrack = progressBarTrack else { return }

		_progressBar.path = UIBezierPath(arcCenter: .zero, radius: bounds.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
		_progressBar.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 2.0)
		_progressBar.strokeEnd = 0.0
		
		_progressBarTrack.path = UIBezierPath(arcCenter: .zero, radius: bounds.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
		_progressBarTrack.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 2.0)
		_progressBarTrack.strokeEnd = 1.0
	}
	
	func updateProgressBar(_ percentage: CGFloat) {
		guard let progressBar = progressBar else { return }
		progressBar.strokeEnd = percentage
	}
	
	func changeColor(_ color: UIColor) {
		guard let progressBar = progressBar else { return }
		progressBar.strokeColor = color.cgColor
	}
	
	func changeWidth(_ width: CGFloat) {
		guard let progressBar = progressBar else { return }
		progressBar.lineWidth = width
	}
	
	func updateColor(_ percentage: CGFloat) {
		guard let progressBar = progressBar else { return }
		
		if (percentage >= 0.5 && percentage <= 0.75) {
			progressBar.strokeColor = StatusColor.medium.cgColor
		} else if (percentage > 0.75) {
			progressBar.strokeColor = StatusColor.high.cgColor
		} else if (percentage >= 0.0 && percentage < 0.5){
			progressBar.strokeColor = StatusColor.low.cgColor
		}
	}
}
