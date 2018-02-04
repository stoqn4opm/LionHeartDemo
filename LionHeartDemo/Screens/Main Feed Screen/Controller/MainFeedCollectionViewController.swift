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
    fileprivate var selectedCell: UICollectionViewCell?
    fileprivate var animator: OpenImageAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Feed".localized
        prepareCollectionView()
        viewModel.start()
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateParallaxStateForVisibleCells()
    }
}

//MARK: - Custom Animation Callbacks

extension MainFeedCollectionViewController: UINavigationControllerDelegate, UIGestureRecognizerDelegate { // UIGestureRecognizerDelegate to fix swipe back gesture
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is EditPhotoViewController {
            animator = nil
        } else {
            animator = OpenImageAnimator()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}

extension MainFeedCollectionViewController: OpenImageAnimatable {
    
    var centeredView: UIView? { return selectedCell }
    var fadeOutViews: [UIView]? { return collectionView?.visibleCells.filter( {!$0.isEqual(selectedCell)}) }
}

//MARK: - CollectionView Callbacks

extension MainFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFeedCell", for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let photoCell = cell as? PhotoFeedCell    else { return }
        guard let photo = viewModel.photoFor(indexPath) else { return }
        photoCell.configureFor(photo)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "photoEditSegue", sender: viewModel.editPhotoViewModelFor(indexPath))
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
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "photoEditSegue" else { return }
        (segue.destination as? EditPhotoViewController)?.viewModel = sender as? EditPhotoViewModel
    }
    
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
