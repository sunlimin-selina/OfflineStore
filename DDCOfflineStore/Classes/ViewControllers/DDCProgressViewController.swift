//
//  DDCProgressViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCProgressViewController: UICollectionViewController {
    
    var stages : Array<DDCContractStateInfoViewModel>? = Array()
    lazy var layout : DDCProgressCollectionViewLayout = {
        var _layout : DDCProgressCollectionViewLayout = DDCProgressCollectionViewLayout.init(stages: self.stages!.count, yOffset: 0.0)
        _layout.delegate = self
        return _layout
    }()
    
    init(stages : Array<DDCContractStateInfoViewModel>) {
        super.init(nibName: nil, bundle: nil)
        self.stages = stages

        self.collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.layout)
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.isScrollEnabled = false;
//        self.collectionView.register(ContractStateInfoCell, forCellWithReuseIdentifier: <#T##String#>)
//        [_collectionView registerClass:[ContractStateInfoCell class] forCellWithReuseIdentifier:NSStringFromClass([ContractStateInfoCell class])];
//        [_collectionView registerClass: [DDCContractStateLineCollectionViewCell class] forCellWithReuseIdentifier: NSStringFromClass([DDCContractStateLineCollectionViewCell class])];
        self.collectionView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DDCProgressViewController : DDCProgressCollectionViewLayoutDelegate {
    func widthForStageAtIndex(index: Int) -> CGFloat {
        return 0.0// [ContractStateInfoCell sizeWithData: self.stages[index]].width;
    }
    
    
}
