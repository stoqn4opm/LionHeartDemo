//
//  GETFlickrFeedNetworkingOperation.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 1.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class GETFlickrFeedNetworkingOperation: BasicNetworkingOperation {
    
    static func start(withCompletion completion: @escaping ([[String : Any]]?, NetworkingError?) -> Void) {
    let operation = GETFlickrFeedNetworkingOperation()
        operation.completion = { (data, error) in
            guard error == nil else { completion(nil, error); return }
            guard let data = data else { completion(nil, NetworkingError(kind: .badResponce)); return }
            guard let jsonRaw = data.jsonDict else { completion(nil, NetworkingError(kind: .badResponce)); return }
            guard let photosRoot = jsonRaw["photos"] as? [String : Any] else { completion(nil, NetworkingError(kind: .badResponce)); return }
            guard let photos = photosRoot["photo"] as? [[String : Any]] else { completion(nil, NetworkingError(kind: .badResponce)); return }
            completion(photos, nil)
        }
        NetworkingOperationManager.shared.startOperation(operation: operation)
    }
    
    private override init(withUrl url: URL) {
        super.init(withUrl: url)
    }
    
   private init() {
        
        let urlString = APIConstants.urls.getRecentPublicPhotosURL
        let url = URL(string: urlString)
        super.init(withUrl: url!)
        request.httpMethod = "GET"
    }
}
