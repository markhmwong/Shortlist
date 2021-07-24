//
//  UIImage+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 21/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UIImage {
	func imageWithColor(color1: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		color1.setFill()

		let context = UIGraphicsGetCurrentContext()
		context?.translateBy(x: 0, y: self.size.height)
		context?.scaleBy(x: 1.0, y: -1.0)
		context?.setBlendMode(CGBlendMode.normal)

		let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
		context?.clip(to: rect, mask: self.cgImage!)
		context?.fill(rect)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage!
	}
	
	func scalePhotoToThumbnail(image: UIImage, width: Double, height: Double) -> UIImage {
		var imageHeight = image.size.height
		var imageWidth = image.size.width

		//square crop
		if imageHeight > imageWidth {
			imageHeight = imageWidth
		}
		else {
			imageWidth = imageHeight
		}

		let size = CGSize(width: imageWidth, height: imageHeight)

		let refWidth : CGFloat = CGFloat(image.cgImage!.width)
		
		let refHeight : CGFloat = CGFloat(image.cgImage!.height)

		let x = (refWidth - size.width) / 2
		let y = (refHeight - size.height) / 2
		
		let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
		return UIImage(cgImage: image.cgImage!.cropping(to: cropRect)!, scale: 1, orientation: image.imageOrientation)
	}
	
	func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: self.size.width + insets.left + insets.right,
				   height: self.size.height + insets.top + insets.bottom), false, self.scale)
		let _ = UIGraphicsGetCurrentContext()
		let origin = CGPoint(x: insets.left, y: insets.top)
		self.draw(at: origin)
		let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return imageWithInsets
	}
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    

}

