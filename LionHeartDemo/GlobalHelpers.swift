//
//  GlobalHelpers.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localizedWith(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
