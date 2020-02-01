//
//  EmptyCollectionView.swift
//  EveryTime
//
//  Created by Mark Wong on 26/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EmptyCollectionView: UIView {
    
    var delegate: MainViewController?
    
	let fontSize = Theme.Font.FontSize.Standard(.b2).value
	
	let fontName = Theme.Font.Regular
	
    lazy var messageLabel: UILabel = {
        let label = UILabel()
		label.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: fontName, size: fontSize)!])
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
		label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
	
	init(message: String) {
		super.init(frame: .zero)
		self.messageLabel.attributedText = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: fontName, size: fontSize)!])
		self.setupView()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
		backgroundColor = .clear
        addSubview(messageLabel)
        messageLabel.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3), left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width - 20.0, height: 0.0))
    }
}
