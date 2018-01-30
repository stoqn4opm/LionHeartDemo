//
//  EditPhotoViewModel.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 30.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class EditPhotoViewModel {
    
    fileprivate(set) var photo: Photo? = Photo.defaultPhoto()
    
    init(withPhoto photo: Photo) {
        self.photo = photo
    }
}

