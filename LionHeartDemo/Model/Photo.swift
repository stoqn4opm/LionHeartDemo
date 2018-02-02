//
//  Photo.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let photoUpdated = NSNotification.Name(rawValue: "photoUpdatedNotification")
}

class Photo {
    
    var image: UIImage? {
        didSet {
        _normalisedImage = nil
         NotificationCenter.default.post(name: .photoUpdated, object: title)
        }
    }
    fileprivate(set) var title: String?
    
    fileprivate var _normalisedImage: UIImage?
    
    fileprivate var farm: Int?
    fileprivate var id: String?
    fileprivate var server: String?
    fileprivate(set) var secret: String?
    
   convenience init(image: UIImage?, title: String?, farm: Int? = nil, id: String? = nil, server: String? = nil, secret: String? = nil) {
    
        self.init(title: title, farm: farm, id: id, server: server, secret: secret)
        self.image = image
    }
    
    init(title: String?, farm: Int? = nil, id: String? = nil, server: String? = nil, secret: String? = nil) {

        self.title = title
        self.farm = farm
        self.id = id
        self.server = server
        self.secret = secret
    }
}

//MARK: - Helpers

extension Photo {
    
    var absoluteURL: URL? {
        
        guard let farm = farm else { return nil }
        guard let id = id else { return nil }
        guard let secret = secret else { return nil }
        guard let server = server else { return nil }
        
        let urlString = APIConstants.urls.absoluteUrlFor(farm: farm, id: id, server: server, secret: secret)
        return URL(string: urlString)
    }

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
