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
    var stages : Int = 1
    var yOffset : CGFloat?
    var cache : Array<UICollectionViewLayoutAttributes> = Array()
    var contentHeight : CGFloat {
        get {
            if self.collectionView != nil {
                let insets : UIEdgeInsets = self.collectionView!.contentInset
                return self.collectionView!.bounds.size.width - (insets.top + insets.bottom)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize
        {
        return CGSize.init(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        if self.cache.count != 0 ,
            self.collectionView == nil { return }

        let lastItemWidth : CGFloat = (self.delegate?.widthForStageAtIndex(index: self.stages - 1))!
        let startingOffset : CGFloat = lastItemWidth / 4
        var xOffset : CGFloat = startingOffset
        let lineWidth : CGFloat = (self.collectionView!.bounds.size.width - (1.5 * lastItemWidth)) / CGFloat((self.stages - 1))

        let numberOfItem : Int = (self.collectionView?.numberOfItems(inSection: 0))! - 1
        
        for index in 0...numberOfItem {
            var frame : CGRect?
            if (index % 2 == 0) // stage
            {
                let itemWidth : CGFloat = (self.delegate?.widthForStageAtIndex(index: index / 2))!
                var x : CGFloat = xOffset
                
                if x > startingOffset {
                    x -= itemWidth / 2
                }
                frame = CGRect.init(x: x, y: 0, width: itemWidth, height: self.contentHeight)
                
                if (index == 0) {
                    xOffset += itemWidth / 2
                }
                
            } else { //line
                frame = CGRect.init(x: xOffset , y: self.yOffset!, width: lineWidth , height: 10)
                xOffset = xOffset + lineWidth
            }
            
            let indexPath : NSIndexPath = NSIndexPath.init(item: index, section: 0)
            let attributes : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath as IndexPath)
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
