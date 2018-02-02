//
//  GETImageNetworkingOperation.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 2.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class GETImageNetworkingOperation: BasicNetworkingOperation {
    
    static func start(forURL url: URL, withCompletion completion: @escaping (UIImage?, NetworkingError?) -> Void) {
        let operation = GETImageNetworkingOperation(withUrl: url)
        operation.completion = { (data, error) in
            guard error == nil       else { completion(nil, error); return }
            guard let imgData = data else { completion(nil, NetworkingError(kind: .badResponce)); return }
            guard let image = UIImage(data: imgData) else { completion(nil, NetworkingError(kind: .badResponce)); return }
            completion(image, nil)
        }
        NetworkingOperationManager.shared.startOperation(operation: operation)
    }
    
    override fileprivate init(withUrl url: URL) {
        super.init(withUrl: url)
        request.httpMethod = "GET"
    }
}
