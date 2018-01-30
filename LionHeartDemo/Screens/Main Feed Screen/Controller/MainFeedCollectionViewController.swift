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
        title = "Photo Feed".localized
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateParallaxStateForVisibleCells()
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

//MARK: - ScrollView Callbacks

extension MainFeedCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateParallaxStateForVisibleCells()
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
    
    fileprivate func updateParallaxStateForVisibleCells() {
        guard let collectionView = collectionView else { return }
        
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoFeedCell else { continue }
            let newCoords = collectionView.convert(cell.center, to: view)
            let parallaxValue = newCoords.y / UIScreen.main.bounds.height * 40 - 20
            cell.updateParalax(to: parallaxValue)
        }
    }
    
    fileprivate func prepareCollectionView() {
        viewModel.collectionView = collectionView
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        let feedLayout = MainFeedCollectionViewLayout()
        collectionView?.setCollectionViewLayout(feedLayout, animated: true)
        feedLayout.delegate = self
    }
}
