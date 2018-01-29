//
//  PhotoFeedCell.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - Configuration

class PhotoFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configureFor(_ photo: Photo) {
        titleLabel.text = photo.title
        imageView.image = photo.image
    }
}
