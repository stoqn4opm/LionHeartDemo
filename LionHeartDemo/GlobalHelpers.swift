//
//  GlobalHelpers.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - String Localisations

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localizedWith(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

//MARK: - Image Size Classes

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

//MARK: - Image Manipulation

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

//MARK: - Log Helper

func printInfo(_ info: Any) {
    #if TEST
        print("\(info)")
    #endif
}

//MARK: - Networking URL Helpers

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    /// http://www.ietf.org/rfc/rfc3986.txt
    /// :returns: Returns percent-escaped string.
    
    var addingPercentEncodingForURLQueryValue: String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Data {
    
    var jsonDict: [String : Any]? {
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) else { return nil }
        return jsonRaw as? [String : Any]
    }
}

extension Dictionary {

    mutating func update(other: Dictionary) {
        for (key,value) in other {
            updateValue(value, forKey:key)
        }
    }
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    /// This percent escapes in compliance with RFC 3986
    /// http://www.ietf.org/rfc/rfc3986.txt
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    var stringFromHttpParameters: String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
