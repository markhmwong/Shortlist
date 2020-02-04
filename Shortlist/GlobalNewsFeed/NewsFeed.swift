//
//  NewsFeed.swift
//  Shortlist
//
//  Created by Mark Wong on 3/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import MarqueeLabel

struct News {
	var tasks: Int
}

class NewsFeedViewModel {
	
	init() {
		
	}
	
}

class NewsFeed: UIView {
	
	lazy var feedLabel: MarqueeLabel = {
		let label = MarqueeLabel.init(frame: .zero, duration: 10.0, fadeLength: 10.0)
		label.attributedText = NSMutableAttributedString(string: "Global Task Tally: 0", attributes: [NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
		label.type = .continuous
		label.textAlignment = .center
		label.animationCurve = .easeInOut
		label.labelize = false
		label.alpha = 0.0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	init(viewModel: NewsFeedViewModel) {
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .clear
		
		addSubview(feedLabel)
		feedLabel.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		feedLabel.restartLabel()
	}
	
	func updateFeed(str: String) {
		feedLabel.attributedText = NSMutableAttributedString(string: "Global Task Tally: \(str)", attributes: [NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
		feedLabel.restartLabel()
	}
	
}
