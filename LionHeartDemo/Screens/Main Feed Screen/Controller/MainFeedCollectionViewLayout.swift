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
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

//MARK: - Properties

extension MainFeedCollectionViewLayout {
    static let columnCount = 2
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
        if cache.isEmpty { prepare() }
        return cache[indexPath.item]
    }
    
    override func prepare() {
        
        // Check requirements
        guard cache.isEmpty == true                 else { return }
        guard let collectionView = collectionView   else { return }
        guard let delegate       = delegate         else { return }
        guard let contentWidth   = contentWidth     else { return }
        
        // Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = contentWidth / CGFloat(MainFeedCollectionViewLayout.columnCount)
        var xOffset: [CGFloat] = []
        for column in 0 ..< MainFeedCollectionViewLayout.columnCount {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: MainFeedCollectionViewLayout.columnCount)
        
        // Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = MainFeedCollectionViewLayout.gap * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: MainFeedCollectionViewLayout.gap, dy: MainFeedCollectionViewLayout.gap)
            
            // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updates the collection view content height
            self.contentHeight = max(contentHeight ?? 0, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (MainFeedCollectionViewLayout.columnCount - 1) ? (column + 1) : 0
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
    func clearCache() { cache.removeAll() }
}
