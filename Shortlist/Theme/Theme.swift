//
//  UIColor+Theme.swift
//  ReadyPlayer
//
//  Created by Mark Wong on 29/6/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct Theme {
    
    struct Font {
        static var Regular: String = "AvenirNext-Medium"
        static var Bold: String = "Avenir-Black"
		static var TitleRegular: String = "Georgia"
		static var TitleBold: String = "Georgia-Bold"
		
        static var DefaultColor: UIColor = .white
		static var FadedColor: UIColor = UIColor.white.adjust(by: -40.0)!
		
        enum StandardSizes: CGFloat {
            //title sizes
            case h0 = 50.0
            case h1 = 30.0
            case h2 = 26.0
            case h3 = 24.0
            case h4 = 20.0
            //body sizes
            case b0 = 15.0
            case b1 = 14.0
            case b2 = 12.0
            case b3 = 11.0
			case b4 = 10.0
			case b5 = 8.0
        }
        
        enum FontSize {
            case Standard(StandardSizes)
            case Custom(CGFloat)
            
            var value: CGFloat {
                switch self {
                case .Standard(let size):
                    switch UIDevice.current.screenType.rawValue {
                    case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
                        return size.rawValue * 0.8
                    case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPad97.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPadPro129.rawValue, UIDevice.ScreenType.iPadPro105.rawValue, UIDevice.ScreenType.iPadPro11.rawValue:
                        return size.rawValue * 1.4
                    default:
                        return size.rawValue
                    }
                case .Custom(let customSize):
                    return customSize
                }
            }
        }
    }
    
    struct Navigation {
        static var background: UIColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
        static var text: UIColor = UIColor.white
    }
    
    struct Cell {
		static var background: UIColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
        static var text: UIColor = UIColor(red:0.91, green:0.53, blue:0.04, alpha:1.0)
		static var textFieldBackground: UIColor = UIColor.black.adjust(by: 3)!
        static var idle: UIColor = .green
        static var inProgress: UIColor = .yellow
		static var taskCompleteColor: UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
		static var highlighted: UIColor = UIColor(red:0.26, green:0.75, blue:0.46, alpha:0.8)
    }
    
    struct GeneralView {
		static var background: UIColor = UIColor.black
		static var headerBackground: UIColor = UIColor(red:0.02, green:0.12, blue:0.20, alpha:1.0)
    }
	
	struct Button {
		static var backgroundColor: UIColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
		static var textColor: UIColor = UIColor.black
		static var cornerRadius: CGFloat = 15.0
		static var donationButtonBackgroundColor: UIColor = UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0)
	}
	
	struct Chart {
		static var lineTaskCompleteColor: UIColor = UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
		static var lineTaskIncompleteColor: UIColor = UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0).adjust(by: 0.0)!
		static var chartLineColor: UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
		static var meanLineColor: UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
		static var chartTitleColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
		static var chartBackgroundColor: UIColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
	}
	
	struct Priority {
		static var highColor: UIColor = UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
		static var mediumColor: UIColor = UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
		static var lowColor: UIColor = UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
		static var noneColor: UIColor = UIColor.white.adjust(by: -30.0)!
	}
}
