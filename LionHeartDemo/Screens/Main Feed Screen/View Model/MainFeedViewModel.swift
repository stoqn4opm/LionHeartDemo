//
//  MainFeedViewModel.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit
import LoadingView

//MARK: - View-model's Life Cycle

class MainFeedViewModel {
    
    weak var collectionView: UICollectionView?
    fileprivate(set) var photos: [Photo] = []
    fileprivate let feedManager = PhotoFeedManager()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(photoArrived), name: PhotoFeedManager.notifications.photoDownloaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willStartAppendingPhotos), name: PhotoFeedManager.notifications.syncWillStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAppendingPhotos), name: PhotoFeedManager.notifications.syncCompleted, object: nil)
    }
    
    func start() {
        #if DUMMY
            loadDummyData()
        #else
            feedManager.startFetching()
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: PhotoFeedManager.notifications.photoDownloaded, object: nil)
        NotificationCenter.default.removeObserver(self, name: PhotoFeedManager.notifications.syncWillStart, object: nil)
        NotificationCenter.default.removeObserver(self, name: PhotoFeedManager.notifications.syncCompleted, object: nil)
    }
}

//MARK: - Population

extension MainFeedViewModel {
    
    fileprivate func loadDummyData() {
        DummyDataProvider.loadDummyPhotos()
    }
    
     @objc fileprivate func photoArrived(_ notification: Notification) {
        guard let photo = notification.object as? Photo else { return }
        let newIndex = photos.count
        photos.append(photo)
        collectionView?.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    @objc fileprivate func willStartAppendingPhotos(_ notification: Notification) {
        collectionView?.isUserInteractionEnabled = false
        LoadingView.show()
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.collectionView?.alpha = 0.6
        })
    }
    
    @objc fileprivate func didEndAppendingPhotos(_ notification: Notification) {
        collectionView?.isUserInteractionEnabled = true
        LoadingView.hide()
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.collectionView?.alpha = 1
        })
    }
}

//MARK: - Data Accessors

extension MainFeedViewModel {
    
    func photoFor(_ indexPath: IndexPath) -> Photo? {
        guard indexPath.row < photos.count else { return nil }
        return photos[indexPath.row]
    }
    
    func sizeForPhoto(at indexPath: IndexPath) -> CGSize {
        return photoFor(indexPath)?.normalisedImage?.size ?? .zero
    }
    
    func editPhotoViewModelFor(_ indexPath: IndexPath) -> EditPhotoViewModel? {
        guard let photo = photoFor(indexPath) else { return nil }
        let result = EditPhotoViewModel(withPhoto: photo)
        return result
    }
}
