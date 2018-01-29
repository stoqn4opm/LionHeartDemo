//
//  MainFeedCollectionViewController.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - ViewController's Life Cycle

class MainFeedCollectionViewController: UICollectionViewController {
    
    fileprivate let viewModel = MainFeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
    }
}

//MARK: - CollectionView Callbacks

extension MainFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFeedCell", for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let photoCell = cell as? PhotoFeedCell else { return }
        photoCell.configureFor(viewModel.photoFor(indexPath))
    }
}

//MARK: - Layout Delegate

extension MainFeedCollectionViewController: MainFeedCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForPhoto(at: indexPath)
    }
}

//MARK: - Helper Methods

extension MainFeedCollectionViewController {
    
    fileprivate func prepareCollectionView() {
        viewModel.collectionView = collectionView
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        let feedLayout = MainFeedCollectionViewLayout()
        collectionView?.setCollectionViewLayout(feedLayout, animated: true)
        feedLayout.delegate = self
    }
}
