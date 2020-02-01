//
//  OnboardingCell.swift
//  Shortlist
//
//  Created by Mark Wong on 8/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
	
	let attributedTextKeysDetails: [NSMutableAttributedString.Key : Any] = [NSMutableAttributedString.Key.font : UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!, NSMutableAttributedString.Key.foregroundColor : UIColor.white]
	
	let attributedTextKeysTitle: [NSMutableAttributedString.Key : Any] = [NSMutableAttributedString.Key.font : UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!, NSMutableAttributedString.Key.foregroundColor : UIColor.white]
	
	var data: OnboardingPage? = nil {
		didSet {
			updateDetails(data?.details ?? "Unknown")
			updateTitle(data?.title ?? "Unknown")
			updateImage(UIImage(named: data?.image ?? "")?.withRenderingMode(.alwaysTemplate))
		}
	}
	
	var coordinator: OnboardingCoordinator? = nil
	
	lazy var skipButton: UIButton = {
		let button = UIButton()
		button.setTitle("Skip", for: .normal)
		button.setTitleColor(Theme.Font.DefaultColor.adjust(by: -40.0)!, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
		return button
	}()
	
	lazy var details: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Unknown"
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = UIColor.black
		label.sizeToFit()
		return label
	}()
	
	lazy var title: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Unknown"
		label.textColor = UIColor.black
		return label
	}()
	
	lazy var image: UIImageView = {
		let image = UIImage(named: "stats.png")?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.white
		view.image?.withRenderingMode(.alwaysTemplate)
		view.contentMode = .scaleAspectFit
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupCell()
	}
	
	private func setupCell() {
		backgroundColor = UIColor.clear
		addSubview(title)
		addSubview(details)
		addSubview(skipButton)
		addSubview(image)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		image.anchorView(top: skipButton.bottomAnchor, bottom: self.centerYAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: bounds.width / 5, left: bounds.width/5, bottom: 0.0, right: -bounds.width / 5), size: .zero)
		
		title.anchorView(top: self.centerYAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: bounds.width / 4, left: bounds.width / 8, bottom: 0.0, right: 0.0), size: .zero)

		details.anchorView(top: title.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 30.0, left: bounds.width / 8, bottom: 0.0, right: -bounds.width / 8), size: .zero)
		
		skipButton.anchorView(top: self.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: self.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: -15.0), size: .zero)
	}
	
	private func updateDetails(_ text: String) {
		DispatchQueue.main.async {
			self.details.attributedText = NSMutableAttributedString(string: text, attributes: self.attributedTextKeysDetails)
		}
	}
	
	private func updateTitle(_ text: String) {
		DispatchQueue.main.async {
			self.title.attributedText = NSMutableAttributedString(string: text, attributes: self.attributedTextKeysTitle)
		}
	}
	
	private func updateImage(_ newImage: UIImage?) {
		image.image = newImage
	}
	
	func updateButton(_ text: String) {
		DispatchQueue.main.async {
			self.skipButton.setTitle(text, for: .normal)
		}
	}
	
	@objc func handleSkip() {
		coordinator?.dismiss(nil)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		details.text = ""
		title.text = ""
	}
}
