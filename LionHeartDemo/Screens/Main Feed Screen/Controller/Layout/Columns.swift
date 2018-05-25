//
//  Columns.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 25/05/2018.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

final class Column {
    
    let xAlignment: CGFloat
    
    private(set) var bottomY: CGFloat = 0
    func updateBottomYTo(_ y: CGFloat) { bottomY = y }
    
    init(xAlignment: CGFloat) {
        self.xAlignment = xAlignment
    }
}


final class ColumnCoordinator {
    
    fileprivate(set) var calculatedAttributes: [UICollectionViewLayoutAttributes] = []
    private(set) var columns: [Column] = []
    private let gapSize: CGFloat
    let columnWidth: CGFloat
    
    init(withColumnsCount columnsCount: Int, inWidth: CGFloat, gapSize: CGFloat) {
        self.gapSize = gapSize
        columnWidth = inWidth / CGFloat(columnsCount)
        
        for i in 0..<columnsCount {
            columns.append(Column(xAlignment: CGFloat(i) * columnWidth))
        }
    }
    
    var shortestColumn: Column { return columns.min { $0.bottomY < $1.bottomY } ?? columns[0] }
    var longestColumn:  Column { return columns.max { $0.bottomY < $1.bottomY } ?? columns[0] }
}

extension ColumnCoordinator {
    
    @discardableResult func attributesFor(_ indexPath: IndexPath, inRestpectToSize size: CGSize) -> UICollectionViewLayoutAttributes {
        
        while !(indexPath.row < calculatedAttributes.count) {
            addItem(withSize: size, at: indexPath)
        }
        return calculatedAttributes[indexPath.row]
    }
    
    private func addItem(withSize itemSize: CGSize, at indexPath: IndexPath) {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if itemSize.isLandscape {
            let x = columns[0].xAlignment
            let y = longestColumn.bottomY
            let width = CGFloat(columns.count) * columnWidth
            let frame = CGRect(x: x, y: y, width: width, height: itemSize.height)
            attributes.frame = frame.insetBy(dx: gapSize, dy: gapSize).nonZeroRect
            columns.forEach { $0.updateBottomYTo(frame.origin.y + frame.size.height) }
        } else {
            let shortestColumn = self.shortestColumn
            let x = shortestColumn.xAlignment
            let y = shortestColumn.bottomY
            let width = columnWidth
            let frame = CGRect(x: x, y: y, width: width, height: itemSize.height)
            attributes.frame = frame.insetBy(dx: gapSize, dy: gapSize).nonZeroRect
            shortestColumn.updateBottomYTo(frame.origin.y + frame.size.height)
        }
        
        calculatedAttributes.append(attributes)
    }
}

extension CGRect {
    
    var nonZeroRect: CGRect {
        return CGRect(x: origin.x == .infinity ? 0 : origin.x,
                      y: origin.y == .infinity ? 0 : origin.y,
                      width: size.width > 0 ? size.width : 30,
                      height: size.height > 0 ? size.height : 30)
    }
}
