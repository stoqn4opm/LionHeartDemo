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
        static let syncFailed = Notification.Name("NetworkingFetchFailed")
        static let syncCompleted = Notification.Name("NetworkingFetchCompleted")
    }
}

class PhotoFeedManager {
    
    static func startFetching() {
        return
        GETFlickrFeedNetworkingOperation.start {(photoList, error) in
            guard error == nil              else { notifyFailure(); return }
            guard let photoList = photoList else { notifyFailure(); return }
            
            for photoEntry in photoList {
                guard let id    = photoEntry["id"]      as? String else { continue }
                guard let title = photoEntry["title"]   as? String else { continue }
                guard let farm  = photoEntry["farm"]    as? Int    else { continue }
                guard let server = photoEntry["server"] as? String else { continue }
                guard let secret = photoEntry["secret"] as? String else { continue }
                
                let photo = Photo(title: title, farm: farm, id: id, server: server, secret: secret)
                downloadImageForPhoto(photo)
            }
        }
    }
    
    private static func downloadImageForPhoto(_ photo: Photo) {
        guard let url = photo.absoluteURL else { return }
        GETImageNetworkingOperation.start(forURL: url, withCompletion: { (image, error) in
            guard let image = image else { return }
            photo.image = image
            NotificationCenter.default.post(name: notifications.syncCompleted, object: photo)
        })
    }
}

//MARK; - Helper Methods

extension PhotoFeedManager {
  fileprivate static func notifyFailure() {
        NotificationCenter.default.post(name: notifications.syncFailed, object: nil)
    }
}
