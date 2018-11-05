//
//  DDCAddContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCAddContractInfoViewController: DDCChildContractViewController {
    var models: [DDCContractModel]?  = Array()
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.isScrollEnabled = false
        _collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.setupViewConstraints()
    }
    
}

// MARK: Private
extension DDCAddContractInfoViewController {
    func setupViewConstraints() {
        let kBarHeight : CGFloat = 60.0
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-kBarHeight)
        }
    }
    
}

// MARK: UICollectionViewDelegate
extension DDCAddContractInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTitleTextFieldCell.self), for: indexPath) as! DDCTitleTextFieldCell
        //        let model: DDCContractInfoViewModel = self.models[indexPath.item]
        //        cell.configureCell(model: model, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if indexPath.item != DDCClientTextFieldType.birthday.rawValue,
        //            indexPath.item != DDCClientTextFieldType.age.rawValue
        //        {
        //            return CGSize.init(width: 500, height: 75)
        //        } else if  indexPath.item == DDCClientTextFieldType.age.rawValue{
        //            return CGSize.init(width: 100, height: 75)
        //        } else {
        //            return CGSize.init(width: 340, height: 75)
        //        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: (screen.width - 500)/2, bottom: 0, right: (screen.width - 500)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 60.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35.0
    }
    
}

// MARK: API
extension DDCAddContractInfoViewController {
    
    func getStoresAndContractTypes() {
        DDCTools.showHUD(view: self.view)
        DDCStoreAndContractTypeAPIManager.getStoresAndContractTypes(successHandler: { (array) in
            
            DDCTools.hideHUD()
        }) { (error) in
            
        }
    }
}
