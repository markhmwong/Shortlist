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

class SettingsHeader: UIViewController {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var viewModel: SettingsHeaderViewModel?
    
    let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!]
    
    lazy var coffeeTip: StandardButton = {
        let button = StandardButton(title: "Small Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleCoffeeTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var generousTip: StandardButton = {
        let button = StandardButton(title: "Medium Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleGenerousTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var amazingTip: StandardButton = {
        let button = StandardButton(title: "Large Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleAmazingTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tipDisclaimer: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Sharing, reviewing, and tipping helps out a lot. If you find this app helped you in a part of your life, show your support by doing one of the three.", attributes: attributes)
        view.backgroundColor = .clear
        view.lineBreakMode = .byWordWrapping
		view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
	lazy var tipButtonContainer: UIStackView = {
		let view = UIStackView()
		view.backgroundColor = .clear
		view.distribution = .fillEqually
		view.spacing = 10
		view.alignment = .fill
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    init(delegate: SettingsViewController, viewModel: SettingsHeaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

    
    override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.GeneralView.headerBackground
		view.addSubview(tipButtonContainer)
		tipButtonContainer.addArrangedSubview(coffeeTip)
		tipButtonContainer.addArrangedSubview(generousTip)
		tipButtonContainer.addArrangedSubview(amazingTip)
		view.addSubview(tipDisclaimer)
		
		guard let _viewModel = viewModel else { return }
		
        _viewModel.buttonArr.append(coffeeTip)
        _viewModel.buttonArr.append(generousTip)
        _viewModel.buttonArr.append(amazingTip)

		//buttons
		let buttonHeight: CGFloat = view.bounds.height * 0.05
		
		tipDisclaimer.anchorView(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 15.0, left: 20.0, bottom: 0.0, right: -20.0), size: CGSize(width: 0.0, height: 0.0))
		
		tipButtonContainer.anchorView(top: tipDisclaimer.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: -20.0, right: -20.0), size: CGSize(width: 0.0, height: buttonHeight))
		
		grabTipsProducts()
    }
    
    func grabTipsProducts() {
        IAPProducts.tipStore.requestProducts { [weak self](success, products) in
            
            guard let self = self else { return }
            
            if (success) {
                guard let products = products else { return }
                self.viewModel?.tipProducts = products
				for product in products {
					print(product.localizedTitle)
				}
                //update buttons
                self.updateTipButtons()
            } else {

				self.hideTipButtons()
            }
        }
    }
	
	func hideTipButtons() {
        guard let tipProductArr = self.viewModel?.tipProducts else { return } //tips are sorted with didSet observer
		let buttonArr = viewModel?.buttonArr
        if (buttonArr!.count == tipProductArr.count) {
            for (index, button) in buttonArr!.enumerated() {
				button.isHidden = true
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
