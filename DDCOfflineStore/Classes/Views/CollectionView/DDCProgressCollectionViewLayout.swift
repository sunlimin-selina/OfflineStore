//
//  DDCProgressCollectionViewLayout.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCProgressCollectionViewLayout : UICollectionViewFlowLayout {
    var delegate : DDCProgressCollectionViewLayoutDelegate?
    var stages : Int?
    var yOffset : CGFloat?
    var cache : [UICollectionViewLayoutAttributes] = []
    var contentHeight : CGFloat {
        get {
            if self.collectionView != nil {
                return DDCProgressViewController.height
            } else {
                return 0.0
            }
        }
    }
    var contentWidth : CGFloat = 0.0

    init(stages : Int, yOffset : CGFloat) {
        super.init()
        self.stages = stages
        self.yOffset = yOffset
        guard #available(iOS 11.0, *) else {
            self.yOffset = 0.0
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize
        {
        return CGSize.init(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        if self.cache.count != 0 || self.collectionView == nil { return }
        super.collectionView?.layoutIfNeeded()

        let lastItemWidth : CGFloat = (self.delegate?.widthForStageAtIndex(index: self.stages! - 1))!
        let startingOffset : CGFloat = lastItemWidth / 4
        var xOffset : CGFloat = startingOffset
        let lineWidth : CGFloat = (self.collectionView!.bounds.size.width - (1.5 * lastItemWidth)) / CGFloat((self.stages! - 1))

        let numberOfItem : Int = (self.collectionView?.numberOfItems(inSection: 0))!
        
        for index in 0...(numberOfItem - 1) {
            var frame : CGRect?
            if (index % 2 == 0) // stage
            {
                let itemWidth: CGFloat = (self.delegate?.widthForStageAtIndex(index: index / 2))!
                var x : CGFloat = xOffset
                
                if x > startingOffset {
                    x -= itemWidth / 2
                }
                frame = CGRect.init(x: x, y: self.yOffset! - 18, width: itemWidth, height: self.contentHeight)
                
                if (index == 0) {
                    xOffset += itemWidth / 2
                }
                
            } else { //line
                frame = CGRect.init(x: xOffset + 9 , y: self.yOffset!, width: lineWidth - 14 , height: 10)
                xOffset += lineWidth
            }
            
            let indexPath : IndexPath = IndexPath.init(item: index, section: 0)
            let attributes : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attributes.frame = frame!
            attributes.zIndex = (index % 2 == 0) ? 0 : 2
            self.cache.append(attributes)
            self.contentWidth = max(self.contentWidth, (frame!.origin.x + frame!.size.width))
        }

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes : Array<UICollectionViewLayoutAttributes> = Array()

        for attribute in self.cache {
            if attribute.frame.intersects(rect) {
                visibleAttributes.append(attribute)
            }
        }
        return visibleAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
    
}

protocol DDCProgressCollectionViewLayoutDelegate {
    func widthForStageAtIndex(index : Int) -> CGFloat
}
