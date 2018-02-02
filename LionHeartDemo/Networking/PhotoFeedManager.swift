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
    }
}

class PhotoFeedManager {
    
    static func loadPhotosWithCompletion(_ completion: @escaping ([Photo]) -> Void) {
        GETFlickrFeedNetworkingOperation.start {(photoList, error) in
            guard error == nil else { notifyFailure(); completion([]); return }
            guard let photoList = photoList else { notifyFailure(); completion([]); return }
            
            var photos: [Photo] = []
            for photoEntry in photoList {
                guard let id    = photoEntry["id"]      as? String else { continue }
                guard let title = photoEntry["title"]   as? String else { continue }
                guard let farm  = photoEntry["farm"]    as? Int    else { continue }
                guard let server = photoEntry["server"] as? String else { continue }
                guard let secret = photoEntry["secret"] as? String else { continue }
                
                let photo = Photo(title: title, farm: farm, id: id, server: server, secret: secret)
                photos.append(photo)
            }
            completion(photos)
        }
    }
}

//MARK; - Helper Methods

extension PhotoFeedManager {
  fileprivate static func notifyFailure() {
        NotificationCenter.default.post(name: notifications.syncFailed, object: nil)
    }
}
