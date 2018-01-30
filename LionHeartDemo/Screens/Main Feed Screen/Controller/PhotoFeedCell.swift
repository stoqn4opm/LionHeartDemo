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
    @IBOutlet weak var parallaxConstraint: NSLayoutConstraint!
    
    func configureFor(_ photo: Photo) {
        titleLabel.text = photo.title
        imageView.image = photo.normalisedImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 9
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
    }
    
    func updateParalax(to value: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {[weak self] in
            self?.parallaxConstraint.constant = -value
        }, completion: nil)
    }
    
    override func prepareForReuse() {
        parallaxConstraint.constant = 0
        imageView.image = nil
        titleLabel.text = nil
    }
}
