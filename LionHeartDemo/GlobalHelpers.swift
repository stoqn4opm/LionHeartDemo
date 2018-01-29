//
//  GlobalHelpers.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localizedWith(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

extension CGSize {
    
    struct photoSizeClasses {
        static let gigantic = CGSize(width: 3999, height: 3999)
        static let big      = CGSize(width: 1999, height: 1999)
        static let normal   = CGSize(width: 999, height: 999)
        static let small    = CGSize(width: 499, height: 499)
        
    }
    
    func tallerThan(_ otherSize: CGSize) -> Bool {
        return height > otherSize.height
    }
    
    func scaledAt(_ scalar: CGFloat) -> CGSize {
        return CGSize(width: width * scalar, height: height * scalar)
    }
}

extension UIImage {
    
    func resizedTo(targetSize: CGSize) -> UIImage? {
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
