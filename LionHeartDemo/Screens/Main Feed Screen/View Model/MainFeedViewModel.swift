//
//  MainFeedViewModel.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - View-model's Life Cycle

class MainFeedViewModel {
    
    weak var collectionView: UICollectionView?
    fileprivate(set) var photos: [Photo] = []
    
    init() {
        #if DUMMY
            loadDummyData()
        #else
            PhotoFeedManager.startFetching()
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(photoArrived), name: PhotoFeedManager.notifications.syncCompleted, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: PhotoFeedManager.notifications.syncCompleted, object: nil)
    }
}

//MARK: - Population

extension MainFeedViewModel {
    
    fileprivate func loadDummyData() {
        DummyDataProvider.loadDummyPhotosWithCompletion {[weak self] (photos) in
            self?.photos = photos
        }
    }
    
     @objc fileprivate func photoArrived(_ notification: Notification) {
        guard let photo = notification.object as? Photo else { return }
        let newIndex = photos.count
        photos.append(photo)
        collectionView?.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
}

//MARK: - Data Accessors

extension MainFeedViewModel {
    
    func photoFor(_ indexPath: IndexPath) -> Photo? {
        guard indexPath.row < photos.count else { return nil }
        return photos[indexPath.row]
    }
    
    func heightForPhoto(at indexPath: IndexPath) -> CGFloat {
        return photoFor(indexPath)?.normalisedImage?.size.height ?? 0
    }
    
    func editPhotoViewModelFor(_ indexPath: IndexPath) -> EditPhotoViewModel? {
        guard let photo = photoFor(indexPath) else { return nil }
        let result = EditPhotoViewModel(withPhoto: photo)
        return result
    }
}
