//
//  WhatsNewViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 7/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {
	
	static let header: String = "WhatsNewHeader"
	
	private var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayoutWithSingleHeader(appearance: .plain, separators: false, header: true, elementKind: header))
		view.backgroundColor = .clear
		view.layer.backgroundColor = UIColor.clear.cgColor
		return view
	}()
	
	private var viewModel: WhatsNewViewModel
	
	init(viewModel: WhatsNewViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
//		addGraphics()
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		viewModel.configureDiffableDataSource(collectionView: tableView)
		
	}
	
//	func addGraphics() {
//		let graphicsLayer: Circle = Circle(frame: CGRect(x: 50, y: 50, width: 100, height: 100), strokeColor: .orange, fillColor: .purple)
//		view.addSubview(graphicsLayer)
//
//		graphicsLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//		graphicsLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//		graphicsLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//		graphicsLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//	}
}

//class Circle: UIView {
//	var strokeColor: UIColor
//	var fillColor: UIColor
//
//	init(frame: CGRect, strokeColor: UIColor, fillColor: UIColor = .clear) {
//		self.strokeColor = strokeColor
//		self.fillColor = fillColor
//		super.init(frame: frame)
//		self.backgroundColor = .clear
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	override func draw(_ rect: CGRect) {
//		let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: frame.height / 2, startAngle: CGFloat(0), endAngle: CGFloat.pi * 2, clockwise: true)
//		strokeColor.setStroke()
//		fillColor.setFill()
//		circlePath.lineWidth = 3
//		circlePath.stroke()
//	}
//}
