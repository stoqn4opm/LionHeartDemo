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
        
        #endif
    }
}

//MARK: - Population

extension MainFeedViewModel {
    
    fileprivate func loadDummyData() {
        DummyDataProvider.loadDummyPhotosWithCompletion {[weak self] (photos) in
            self?.photos = photos
        }
    }
}

//MARK: - Data Accessors

extension MainFeedViewModel {
    
    func photoFor(_ indexPath: IndexPath) -> Photo {
        guard let photos = photos          else { return Photo.defaultPhoto() }
        guard indexPath.row < photos.count else { return Photo.defaultPhoto() }
        return photos[indexPath.row]
    }
    
    func heightForPhoto(at indexPath: IndexPath) -> CGFloat {
        return photoFor(indexPath).image?.size.height ?? 0
    }
}
