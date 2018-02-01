//
//  NetworkingOperationManager.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 1.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class NetworkingOperationManager {
    
    static let shared = NetworkingOperationManager()
    
    fileprivate let operationQueue: OperationQueue = {
        let result = OperationQueue()
        result.name = "API Operation Queue"
        return result
    }()
    
    func startOperation(operation: BasicOperation) {
        operationQueue.addOperation(operation)
    }
}

