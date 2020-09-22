//
//  Extension+UIColor.swift
//  EveryTime
//
//  Created by Mark Wong on 30/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UIColor {
	// Neumorphic colors
	static var offWhite: UIColor = UIColor.init(red: 235/255, green: 235/255, blue: 245/255, alpha: 1.0)
	
	
	
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
