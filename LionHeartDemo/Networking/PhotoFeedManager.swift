//
//  PhotoFeedManager.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 1.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

extension PhotoFeedManager {
    struct notifications {
        static let syncWillStart    = Notification.Name("NetworkingFetchWillStart")
        static let photoDownloaded  = Notification.Name("NetworkingFetchSinglePhotoCompleted")
        static let syncCompleted    = Notification.Name("NetworkingFetchCompleted")
        static let syncFailed       = Notification.Name("NetworkingFetchFailed")
    }
}

class PhotoFeedManager {
    
    fileprivate(set) var expectedPhotos: Int = 0
    fileprivate(set) var receivedPhotos: Int = 0
    
    func startFetching() {
        
        expectedPhotos = 0
        receivedPhotos = 0
        NotificationCenter.default.post(name: notifications.syncWillStart, object: nil)
        
        GETFlickrFeedNetworkingOperation.start {[weak self] (photoList, error) in
            guard error == nil              else { PhotoFeedManager.notifyFailure(); return }
            guard let photoList = photoList else { PhotoFeedManager.notifyFailure(); return }
            self?.expectedPhotos = photoList.count
            
            for photoEntry in photoList {
                guard let id    = photoEntry["id"]      as? String else { continue }
                guard let title = photoEntry["title"]   as? String else { continue }
                guard let farm  = photoEntry["farm"]    as? Int    else { continue }
                guard let server = photoEntry["server"] as? String else { continue }
                guard let secret = photoEntry["secret"] as? String else { continue }
                
                let photo = Photo(title: title, farm: farm, id: id, server: server, secret: secret)
                self?.downloadImageForPhoto(photo)
            }
        }
    }
    
    private func downloadImageForPhoto(_ photo: Photo) {
        guard let url = photo.absoluteURL else { return }
        GETImageNetworkingOperation.start(forURL: url, withCompletion: {[weak self] (image, error) in
            guard let image = image else { return }
            photo.image = image
            self?.receivedPhotos += 1
            NotificationCenter.default.post(name: notifications.photoDownloaded, object: photo)
            
            if self?.expectedPhotos == self?.receivedPhotos {
                NotificationCenter.default.post(name: notifications.syncCompleted, object: photo)
            }
        })
    }
}

//MARK; - Helper Methods

extension PhotoFeedManager {
  fileprivate static func notifyFailure() {
        NotificationCenter.default.post(name: notifications.syncFailed, object: nil)
    }
}
