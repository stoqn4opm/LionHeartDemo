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
    
    fileprivate(set) var image: UIImage?
    fileprivate(set) var title: String?
    
    
    init(image: UIImage?, title: String?) {
        
        self.image = image ?? Photo.defaultPhoto().image
        self.title = title ?? Photo.defaultPhoto().title
    }
}
