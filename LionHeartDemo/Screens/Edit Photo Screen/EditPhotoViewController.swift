//
//  EditPhotoViewController.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 30.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {

    @IBOutlet weak var editContainerBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var editContainer: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    var viewModel: EditPhotoViewModel?
    
    fileprivate var isInEditMode: Bool? {
        didSet {
            editContainerBottomConstaint.constant = isInEditMode == true ? -60 : -200
            view.setNeedsUpdateConstraints()
            editButton.title = isInEditMode == true ? "Cancel".localized : "Edit".localized
            saveButton.isEnabled = isInEditMode == true
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {[weak self] in
                
                self?.view.layoutIfNeeded()
                self?.editContainer.isUserInteractionEnabled = self?.isInEditMode == true

            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = viewModel?.photo?.image
        title = viewModel?.photo?.title
        isInEditMode = false
        editContainer.layer.cornerRadius = 9
        editContainer.clipsToBounds = true
    }
}

//MARK: - User Actions

extension EditPhotoViewController {
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let image = viewModel?.photo?.image else { return }
        guard let title = viewModel?.photo?.title else { return }
        isInEditMode = false
        
        let shareController = UIActivityViewController(activityItems: [image, title], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = isInEditMode == true ? false : true
    }
}
