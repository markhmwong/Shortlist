//
//  SettingsHeader.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class SettingsHeaderViewModel {
    var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
    var buttonArr: [StandardButton] = []
}

class SettingsHeader: UIView {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var viewModel: SettingsHeaderViewModel?
    
    let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!]
    
    lazy var coffeeTip: StandardButton = {
        let button = StandardButton(title: "Short Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleCoffeeTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var generousTip: StandardButton = {
        let button = StandardButton(title: "Tall Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleGenerousTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var amazingTip: StandardButton = {
        let button = StandardButton(title: "Grande Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleAmazingTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var promoText: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "If you find this app useful for your daily activities, please consider supporting the app by leaving a tip in my tip jar.", attributes: attributes)
        view.backgroundColor = .clear
        view.lineBreakMode = .byWordWrapping
		view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
	lazy var tipButtonContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(delegate: SettingsViewController, viewModel: SettingsHeaderViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		tipButtonContainer.anchorView(top: promoText.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0), size: .zero)
		promoText.anchorView(top: topAnchor, bottom: tipButtonContainer.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 15.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))
		generousTip.anchorView(top: tipButtonContainer.topAnchor, bottom: tipButtonContainer.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: tipButtonContainer.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: -10.0), size: CGSize(width: 120.0, height: 60.0))
		coffeeTip.anchorView(top: tipButtonContainer.topAnchor, bottom: tipButtonContainer.bottomAnchor, leading: nil, trailing: generousTip.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: 120.0, height: 60.0))
		amazingTip.anchorView(top: tipButtonContainer.topAnchor, bottom: tipButtonContainer.bottomAnchor, leading: generousTip.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 0.0), size: CGSize(width: 120.0, height: 60.0))
	}
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Theme.GeneralView.headerBackground
		addSubview(tipButtonContainer)
		tipButtonContainer.addSubview(coffeeTip)
		tipButtonContainer.addSubview(generousTip)
		tipButtonContainer.addSubview(amazingTip)
		addSubview(promoText)
		
		guard let _viewModel = viewModel else { return }
		
        _viewModel.buttonArr.append(coffeeTip)
        _viewModel.buttonArr.append(generousTip)
        _viewModel.buttonArr.append(amazingTip)

    }
    
    func grabTipsProducts() {
        IAPProducts.tipStore.requestProducts { [weak self](success, products) in
            
            guard let self = self else { return }
            
            if (success) {
                guard let products = products else { return }
                self.viewModel?.tipProducts = products
                //update buttons
                self.updateTipButtons()
            } else {
                // requires internet access
            }
        }
    }
    
    func updateTipButtons() {
        guard let tipProductArr = self.viewModel?.tipProducts else { return } //tips are sorted with didSet observer
        let buttonArr = viewModel?.buttonArr
        if (buttonArr!.count == tipProductArr.count) {
            for (index, button) in buttonArr!.enumerated() {
                SettingsHeader.priceFormatter.locale = tipProductArr[index].priceLocale
                let price = SettingsHeader.priceFormatter.string(from: tipProductArr[index].price)
                DispatchQueue.main.async {
                    button.setAttributedTitle(NSAttributedString(string: "\(tipProductArr[index].localizedTitle) \(price!)", attributes: self.attributes), for: .normal)
                }

                button.product = tipProductArr[index]
                button.buyButtonHandler = { product in
                    IAPProducts.tipStore.buyProduct(product)
                }
            }
        }
    }
    
    @objc func handleCoffeeTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleGenerousTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleAmazingTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
}
