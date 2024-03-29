//
//  String+Extension.swift
//  Five
//
//  Created by Mark Wong on 3/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension String {
	
	// Replace all characters except spaces (and other space types such as tabs etc)
	// to be tested
	
	// Regular expression break down
	// "\" - escape the following backslash.. because Swift wraps strings with quotations
	// "\S" - matches all non whitespace characters
	// This replaces each character with a * except for white spaces

	func replaceAllCharacters(with: String) -> String {
		return self.replacingOccurrences(of: "\\S", with: "*", options: .regularExpression)
	}
	
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
	
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
