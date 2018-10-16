//
//  DDCProgressViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCProgressViewController: UIViewController {
    
    var stages: Array<DDCContractStateInfoViewModel>? {
        didSet {
            if let _collectionView = self.collectionView {
                _collectionView.reloadData()
            }
        }
    }
    
    lazy var collectionView: UICollectionView! = {
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.layout!)
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.isScrollEnabled = false;
        _collectionView.register(DDCContractStateInfoCell.self, forCellWithReuseIdentifier: String(describing: DDCContractStateInfoCell.self))//DDCContractStateLineCollectionViewCell
        _collectionView.register(DDCContractStateLineCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractStateLineCollectionViewCell.self))
        _collectionView.backgroundColor = UIColor.white
        return _collectionView
    }()
    
    lazy var layout : DDCProgressCollectionViewLayout! = {
        var _layout : DDCProgressCollectionViewLayout = DDCProgressCollectionViewLayout.init(stages: self.stages!.count, yOffset: 0.0)
        _layout.delegate = self
        return _layout
    }()
    
    init(stages : Array<DDCContractStateInfoViewModel>) {
        super.init(nibName: nil, bundle: nil)
        self.stages = stages
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
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

extension DDCProgressViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stages!.count * 2 - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item % 2 == 0) // stage
        {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractStateInfoCell.self), for: indexPath)
//            ContractStateInfoViewModel *model = self.stages[indexPath.item/2];
//            [cell configureCellWithData:model];
            return cell
        }
        else // line
        {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractStateLineCollectionViewCell.self), for: indexPath)

//            ContractStateInfoViewModel *model = self.stages[(indexPath.item - 1) / 2];
//            [cell configureCellWithStyle: model.state == ContractStateDone ? DDCLineStyleSolid : DDCLineStyleDotted];
            return cell
        }
    }
}
