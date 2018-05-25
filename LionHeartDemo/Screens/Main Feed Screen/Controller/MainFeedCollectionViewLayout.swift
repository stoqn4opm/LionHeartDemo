//
//  MainFeedCollectionViewLayout.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 29.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - MainFeedCollectionViewLayoutDelegate

protocol MainFeedCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

//MARK: - Properties

extension MainFeedCollectionViewLayout {
    static let maxColumnCount = 2
    static let gap: CGFloat = 6
}

class MainFeedCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentHeight: CGFloat?
    
    
    fileprivate var contentWidth: CGFloat? {
        guard let collectionView = collectionView else { return nil }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    weak var delegate: MainFeedCollectionViewLayoutDelegate?
}

//MARK: - Layout Preparation

extension MainFeedCollectionViewLayout {
    
    override var collectionViewContentSize: CGSize { return CGSize(width: contentWidth ?? 0, height: contentHeight ?? 0) }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if indexPath.item == cache.count {
            calculateAttributeFor(indexPath)
        }
        
        clearCache()
        prepare()
        return cache[indexPath.item]
    }
    
    fileprivate func calculateAttributeFor(_ indexPath: IndexPath) {
        
//        cache.append()
    }
    
    override func prepare() {
        
        // Check requirements
        guard cache.isEmpty == true                 else { return }
        guard let collectionView = collectionView   else { return }
        guard let delegate       = delegate         else { return }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: MainFeedCollectionViewLayout.maxColumnCount)
        
        // Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let photoSize = delegate.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath)
            let height = MainFeedCollectionViewLayout.gap * 2 + photoSize.height
            let frame = CGRect(x: xOffsetFor(column, columnWidth: columnWidth), y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: MainFeedCollectionViewLayout.gap, dy: MainFeedCollectionViewLayout.gap)
            
            // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updates the collection view content height
            contentHeight = max(contentHeight ?? 0, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (MainFeedCollectionViewLayout.maxColumnCount - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            guard attributes.frame.intersects(rect) == true else { continue }
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }
}

//MARK: - Helper Functions

extension MainFeedCollectionViewLayout {
    
    fileprivate var columnWidth: CGFloat {
        guard let contentWidth = contentWidth else { return  0 }
        return contentWidth / CGFloat(MainFeedCollectionViewLayout.maxColumnCount)
    }
    
    fileprivate func xOffsetFor(_ column: Int, columnWidth: CGFloat) -> CGFloat {
        return CGFloat(column) * columnWidth
    }
    
    func clearCache() { cache.removeAll() }
}
