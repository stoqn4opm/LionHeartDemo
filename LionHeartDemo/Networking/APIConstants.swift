//
//  APIConstants.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 1.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

struct APIConstants {
    
    static let apiKey = "658fd8f4970257b0786dde36a924b6de"
    static let secret = "29755a4f85385a0b"
    
    struct methods {
        static let getRecentPublicPhotos = ["method" : "flickr.photos.getRecent"]
    }
    
    struct formats {
        static let jsonFormat = ["format" : "json", "nojsoncallback": "1"]
    }
    
    struct urls {
        
        static var baseURL: String {
            #if PROD
                return "https://api.flickr.com/services/rest/"
            #elseif TEST
                return "https://api.flickr.com/services/rest/"
            #else
                return ""
            #endif
        }
        
        static var getRecentPublicPhotosURL: String {
            var parameters: [String: String] = [:]
            parameters.update(other: methods.getRecentPublicPhotos)
            parameters.update(other: formats.jsonFormat)
            parameters["api_key"] = APIConstants.apiKey
            return baseURL + "?\(parameters.stringFromHttpParameters)"
        }
    }
}
