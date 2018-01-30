//
//  Photo.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

extension Photo {
    static func defaultPhoto() -> Photo {
        return Photo(image: UIImage(named:"thumbnail") , title:"test photo")
    }
}

class Photo {
    
    fileprivate(set) var image: UIImage? { didSet { _normalisedImage = nil } }
    fileprivate(set) var title: String?
    
    fileprivate var _normalisedImage: UIImage?
    
    init(image: UIImage?, title: String?) {
        
        self.image = image ?? Photo.defaultPhoto().image
        self.title = title ?? Photo.defaultPhoto().title
    }
}

//MARK: - Helpers

extension Photo {

    var normalisedImage: UIImage? {
    
        guard _normalisedImage == nil   else { return _normalisedImage }
        guard let originalImage = image else { return nil }
        
        if originalImage.size.tallerThan(CGSize.photoSizeClasses.gigantic) {
            let scaleDownFactor = originalImage.size.height / CGSize.photoSizeClasses.normal.height
            let desiredHeight   = originalImage.size.height / scaleDownFactor
            let desiredWidth = originalImage.size.width / scaleDownFactor
            _normalisedImage = originalImage.resizedTo(targetSize: CGSize(width: desiredWidth, height: desiredHeight))
        }
        else if originalImage.size.tallerThan(CGSize.photoSizeClasses.big) {
            _normalisedImage = originalImage.resizedTo(targetSize: originalImage.size.scaledAt(0.1))
        }
        else if originalImage.size.tallerThan(CGSize.photoSizeClasses.normal) {
            _normalisedImage = originalImage.resizedTo(targetSize: originalImage.size.scaledAt(0.2))
        }
        else if originalImage.size.tallerThan(CGSize.photoSizeClasses.small) {
            _normalisedImage = originalImage.resizedTo(targetSize: originalImage.size.scaledAt(0.8))
        } else {
            _normalisedImage = originalImage
        }

        return _normalisedImage
    }
}
