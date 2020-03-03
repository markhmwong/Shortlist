//
//  File.swift
//  Shortlist
//
//  Created by Mark Wong on 9/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum StatContainerType {
	case TotalTasks
	case CompleteTasks
	case IncompleteTasks
}

class StatContainer: UIView {
	
	lazy var statNumber: UILabel = {
		let view = UILabel()
		view.textAlignment = .center
		view.backgroundColor = UIColor.clear
		view.textColor = .white
		view.font = UIFont(name: Theme.Font.Bold, size: 32.0)!
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var statTitle: UILabel = {
		let view = UILabel()
		view.textAlignment = .center
		view.backgroundColor = UIColor.clear
		view.textColor = .white
		view.font = UIFont(name: Theme.Font.Bold, size: 12.0)!
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var circleBackground: CAShapeLayer = {
		let shape = CAShapeLayer()
		shape.fillColor = Theme.Chart.chartBackgroundColor.cgColor
		return shape
	}()
	
	lazy var circleBorder: CAShapeLayer = {
		let shape = CAShapeLayer()
		shape.fillColor = UIColor.white.adjust(by: -10.0)!.cgColor
		return shape
	}()
	
	var title: String = ""
	
	let type: StatContainerType
	
	weak var persistentContainer: PersistentContainer? = nil
	
	init(persistentContainer: PersistentContainer?, type: StatContainerType) {
		self.persistentContainer = persistentContainer
		self.type = type
		super.init(frame: .zero)
		self.setupView()
	}
	
	required init?(coder: NSCoder) {
		self.type = .TotalTasks
		super.init(coder: coder)
	}
	
	private func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .clear
		
		// grab values from Core Data
		configureStatType(type: type)
		layer.addSublayer(circleBorder)
		layer.addSublayer(circleBackground)
		
		addSubview(statNumber)
		statNumber.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: centerYAnchor, centerX: nil, padding: .zero, size: .zero)
		
		addSubview(statTitle)
		statTitle.anchorView(top: statNumber.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let path = UIBezierPath(arcCenter: .zero, radius: bounds.maxX / 2.8, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		circleBackground.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 1.8)
		circleBackground.path = path.cgPath
		
		let pathB = UIBezierPath(arcCenter: .zero, radius: bounds.maxX / 2.7, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		circleBorder.position = CGPoint(x: bounds.maxX / 2.0, y: bounds.maxY / 1.8)
		circleBorder.path = pathB.cgPath
	}
	
	func configureStatType(type: StatContainerType) {
		switch type {
			case .CompleteTasks:
				if let stat: Stats = persistentContainer?.fetchStatEntity() {
//					statNumber.text = "\(stat.totalCompleteTasks)"
					statNumber.text = "47"
				} else {
					statNumber.text = "0"
				}
				statTitle.text = "Complete"
			case .IncompleteTasks:
				if let stat: Stats = persistentContainer?.fetchStatEntity() {
//					statNumber.text = "\(stat.totalIncompleteTasks)"
					statNumber.text = "23"
				} else {
					statNumber.text = "0"
				}
				statTitle.text = "Incomplete"
			case .TotalTasks:
				if let stat: Stats = persistentContainer?.fetchStatEntity() {
//					statNumber.text = "\(stat.totalTasks)"
					statNumber.text = "70"
				} else {
					statNumber.text = "0"
				}
				statTitle.text = "Total"
		}
	}
}
