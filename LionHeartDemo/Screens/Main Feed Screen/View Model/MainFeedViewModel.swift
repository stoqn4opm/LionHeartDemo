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
    fileprivate(set) var photos: [Photo]? {
        didSet {
            (collectionView?.collectionViewLayout as? MainFeedCollectionViewLayout)?.clearCache()
            collectionView?.reloadSections([0])
        }
    }
    
    init() {
        #if DUMMY
            loadDummyData()
        #else
            loadData()
        #endif
    }
}

//MARK: - Population

extension MainFeedViewModel {
    
    fileprivate func loadData() {
        PhotoFeedManager.loadPhotosWithCompletion {[weak self] (photos) in
            self?.photos = photos
        }
    }
    
    fileprivate func loadDummyData() {
        DummyDataProvider.loadDummyPhotosWithCompletion {[weak self] (photos) in
            self?.photos = photos
        }
    }
}

//MARK: - Data Accessors

extension MainFeedViewModel {
    
    func photoFor(_ indexPath: IndexPath) -> Photo? {
        guard let photos = photos          else { return nil }
        guard indexPath.row < photos.count else { return nil }
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
