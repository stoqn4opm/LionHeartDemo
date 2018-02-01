//
//  BasicNetworkingOperation.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 1.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

//MARK: - Possible HTTP Errors

struct NetworkingError: Error {
    enum ErrorKind {
        case nonHHTPResponce
        case deviceConnectionError
        case serverError
        case badResponce
        case unauthorized
        case notFoundError
    }
    
    let kind: ErrorKind
    
    init(kind: ErrorKind) {
        self.kind = kind
        printInfo("[NetworkingError] Error of kind: '\(kind)' occured")
    }
}

typealias OperationCompletionBlock = ((_ result: Data?, _ error: NetworkingError?) -> Void)

//MARK: - Life Cycle

class BasicNetworkingOperation: BasicOperation {
    
    var request: URLRequest
    var completion: OperationCompletionBlock?
    
    init(withUrl url: URL) {
        request = URLRequest(url: url)
        super.init()
    }
    
    override func main() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let dataTask = session.dataTask(with: request, completionHandler: {[weak self] (data, response, error) -> Void in
                guard let strongSelf = self else { return }
                guard strongSelf.isCancelled == false else {
                    strongSelf.state = .finished
                    return
                }
                strongSelf.handleResponse(data: data, error: error, response: response)
            })
            dataTask.resume()
        }
    }
}

//MARK: - Response Handling

extension BasicNetworkingOperation {
    
    func handleResponse(data: Data? ,error: Error?, response: URLResponse?) {
        if let operationCompletion = completion {
            
            guard error == nil else {
                DispatchQueue.main.async {
                    operationCompletion(nil, NetworkingError(kind: .deviceConnectionError))
                }
                state = .finished
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 500 {
                    
                    DispatchQueue.main.async {
                        operationCompletion(nil, NetworkingError(kind: .serverError))
                    }
                    state = .finished
                    return
                }
                else if httpResponse.statusCode == 404 {
                    
                    DispatchQueue.main.async {
                        operationCompletion(nil, NetworkingError(kind: .notFoundError))
                    }
                    state = .finished
                    return
                }
                else if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        operationCompletion(data, nil)
                    }
                    state = .finished
                    return
                }
                else if httpResponse.statusCode == 401 {
                    
                    DispatchQueue.main.async {
                        operationCompletion(nil, NetworkingError(kind: .unauthorized))
                    }
                    state = .finished
                    return
                }
            }
            
            DispatchQueue.main.async {
                operationCompletion(nil, NetworkingError(kind: .nonHHTPResponce))
            }
            state = .finished
        }
    }
}
