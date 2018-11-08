//
//  DDCProgressViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCProgressViewController: UIViewController {
    static let height: CGFloat = 170.0
    
    var stages: Array<DDCContractStateInfoViewModel>? {
        didSet {
            if let _collectionView = self.collectionView {
                _collectionView.reloadData()
            }
        }
    }
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()

        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        _collectionView.setCollectionViewLayout(self.layout, animated: true)
        _collectionView.showsHorizontalScrollIndicator = false 
        _collectionView.isScrollEnabled = false 
        _collectionView.register(DDCContractStateInfoCell.self, forCellWithReuseIdentifier: String(describing: DDCContractStateInfoCell.self))
        _collectionView.register(DDCContractStateLineCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractStateLineCollectionViewCell.self))
        _collectionView.backgroundColor = UIColor.white
        return _collectionView
    }()
    
    lazy var layout : DDCProgressCollectionViewLayout! = {
        var _layout : DDCProgressCollectionViewLayout = DDCProgressCollectionViewLayout.init(stages: self.stages!.count, yOffset: DDCProgressViewController.height / 2)
        _layout.delegate = self
        return _layout
    }()
    
    init(stages : Array<DDCContractStateInfoViewModel>) {
        super.init(nibName: nil, bundle: nil)
        self.stages = stages
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

extension DDCProgressViewController : DDCProgressCollectionViewLayoutDelegate {
    func widthForStageAtIndex(index: Int) -> CGFloat {
        return DDCContractStateInfoCell.size(data: self.stages![index]).width
    }
}

extension DDCProgressViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stages!.count * 2 - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.item % 2 == 0) // stage
        {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractStateInfoCell.self), for: indexPath) as! DDCContractStateInfoCell
            let model: DDCContractStateInfoViewModel = self.stages![indexPath.item/2]
            cell.configureCell(model: model)
            return cell
        }
        else // line
        {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractStateLineCollectionViewCell.self), for: indexPath) as! DDCContractStateLineCollectionViewCell
            let model: DDCContractStateInfoViewModel = self.stages![(indexPath.item - 1) / 2]
            cell.configureCell(style: model.state == DDCContractState.done ? DDCLineStyle.solid : DDCLineStyle.dotted)
            return cell
        }
    }

}
