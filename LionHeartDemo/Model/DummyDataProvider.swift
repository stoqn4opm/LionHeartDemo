//
//  DummyDataProvider.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class DummyDataProvider {
    
    static func loadDummyPhotos() {
        var timeInterval: TimeInterval = 0
        
        for photo in dummyPhotos {
            timeInterval += 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: {
                
                NotificationCenter.default.post(name: PhotoFeedManager.notifications.syncCompleted, object: photo)
            })
        }
    }
    
    static let dummyPhotos: [Photo] = {
        
        let photos = [
            Photo(image: UIImage(named: "abobo"),       title: "abobo"),
            Photo(image: UIImage(named: "appleRetro"),  title: "appleRetro"),
            Photo(image: UIImage(named: "background"),  title: "background"),
            Photo(image: UIImage(named: "battleToadsDoubleDragons"), title: "battleToadsDoubleDragons"),
            Photo(image: UIImage(named: "contraNes"),   title: "contraNes"),
            Photo(image: UIImage(named: "cuphead"),     title: "cuphead"),
            Photo(image: UIImage(named: "cuphead1"), 	title: "cuphead1"),
            Photo(image: UIImage(named: "doubleDragons"), title: "doubleDragons"),
            Photo(image: UIImage(named: "homer1"), 	    title: "homer1"),
            Photo(image: UIImage(named: "homer2"),      title: "homer2"),
            Photo(image: UIImage(named: "homer3"),      title: "homer3"),
            Photo(image: UIImage(named: "homerMarge"),  title: "homerMarge"),
            Photo(image: UIImage(named: "ken"),         title: "ken"),
            Photo(image: UIImage(named: "mario"),       title: "mario"),
            Photo(image: UIImage(named: "marioEvolution"), title: "marioEvolution"),
            Photo(image: UIImage(named: "megaman"),     title: "megaman"),
            Photo(image: UIImage(named: "dsafdsgsav"),  title: "sdcdsvdfvadfbd"),
            Photo(image: nil,                           title: nil),
            Photo(image: UIImage(named: "nes"),         title: "nes"),
            Photo(image: UIImage(named: "nesMegaman"),  title: "nesMegaman"),
            Photo(image: UIImage(named: "pacman"),      title: "pacman"),
            Photo(image: UIImage(named: "retroCityRampage"), title: "retroCityRampage"),
            Photo(image: UIImage(named: "snes"),        title: "snes"),
            Photo(image: UIImage(named: "sonic"),       title: "sonic"),
            Photo(image: UIImage(named: "spongebob"),   title: "spongebob"),
            Photo(image: UIImage(named: "tmnt"),        title: "tmnt"),
            Photo(image: UIImage(named: "tmnt3Nes"),    title: "tmnt3Nes"),
            Photo(image: UIImage(named: "tmnt3Nes1"),   title: "tmnt3Nes1"),
            Photo(image: UIImage(named: "zen"),         title: "zen"),
            Photo(image: UIImage(named: "zen1"),        title: "zen1")]
        
        return photos
        
    }()
}
