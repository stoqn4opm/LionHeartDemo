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
    
    fileprivate var contentHeight: CGFloat?
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    weak var delegate: MainFeedCollectionViewLayoutDelegate?
    fileprivate lazy var coordinator = ColumnCoordinator(withColumnsCount: 2, inWidth: contentWidth, gapSize: 6)
}

//MARK: - Layout Preparation

extension MainFeedCollectionViewLayout {
    
    override var collectionViewContentSize: CGSize { return CGSize(width: contentWidth, height: contentHeight ?? 0) }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView   else { return nil }
        guard let delegate = delegate else { return nil }
        let photoSize = delegate.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath)
        contentHeight = coordinator.longestColumn.bottomY
        return coordinator.attributesFor(indexPath, inRestpectToSize: photoSize)
    }
    
    override func prepare() {
        
        // Check requirements
        guard let collectionView = collectionView   else { return }
        guard let delegate       = delegate         else { return }
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath)
            coordinator.attributesFor(indexPath, inRestpectToSize: photoSize)
            contentHeight = coordinator.longestColumn.bottomY
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in coordinator.calculatedAttributes {
            guard attributes.frame.intersects(rect) == true else { continue }
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }
}

