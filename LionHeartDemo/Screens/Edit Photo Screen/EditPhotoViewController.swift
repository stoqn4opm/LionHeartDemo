//
//  EditPhotoViewController.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 30.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var viewModel: EditPhotoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = viewModel?.photo?.image
        title = viewModel?.photo?.title
    }
}

//MARK: - User Actions

extension EditPhotoViewController {
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let image = viewModel?.photo?.image else { return }
        guard let title = viewModel?.photo?.title else { return }
        
        let shareController = UIActivityViewController(activityItems: [image, title], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    }
}
