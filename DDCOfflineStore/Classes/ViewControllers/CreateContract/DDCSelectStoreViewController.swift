//
//  DDCSelectStoreViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCSelectStoreViewController: DDCChildContractViewController {
    var models: [DDCContractModel]?  = Array()
    var stores: [DDCCheckBoxModel]?  = Array()
    var selectedStore: DDCCheckBoxModel?
    var selectedType: Int?
    
    var userInfo: [DDCContractDetailsViewModel] = Array()
    var saleTypes: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "体验课订单", isSelected: false),DDCCheckBoxModel.init(id: nil, title: "普通合同", isSelected: false),DDCCheckBoxModel.init(id: nil, title: "团体合同", isSelected: false)]
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCRadioButtonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self))
        _collectionView.register(DDCContractDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self))
        _collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            self.delegate?.previousPage(model: self.model!)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
            self.forwardNextPage()
        }))
        _bottomBar.buttonArray![1].isEnabled = false
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.getStoresAndContractTypes()
        self.automaticallyAdjustsScrollViewInsets = false
        self.userInfo = DDCContractDetailsViewModelFactory.integrateUserData(model: self.model!)
        
    }
    
}

// MARK: Private
extension DDCSelectStoreViewController {
    func setupViewConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-DDCAppConfig.kBarHeight)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })
    }
    
    func forwardNextPage() {
//        self.bottomBar.buttonArray![1].isEnabled = false
        var canForward: Bool = true
        
//        if !canForward {
//            self.bottomBar.buttonArray![0].isEnabled = true
//            DDCTools.showHUD(view: self.view)
//        }
        
        self.model!.currentStore = (self.selectedStore as! DDCStoreModel)
        self.model!.courseType = DDCCourseType(rawValue: self.selectedType!)!
        
        self.delegate?.nextPage(model: self.model!)
    }
}

// MARK: API
extension DDCSelectStoreViewController {
    
    func getStoresAndContractTypes() {
        if (self.stores?.count)! > 0 {
            return
        }
        DDCTools.showHUD(view: self.view)
        DDCStoreAndContractTypeAPIManager.getStoresAndContractTypes(successHandler: { (array) in
            DDCTools.hideHUD()
            self.stores = array
            self.collectionView.reloadData()
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
}

// MARK: Action
extension DDCSelectStoreViewController {
    
    func didSelectRadioButton(sender: UIButton) {
        
    }
}

// MARK: UICollectionViewDelegate
extension DDCSelectStoreViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.userInfo.count
        } else if section == 1 {
            return self.stores!.count
        }
        return self.saleTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self), for: indexPath) as! DDCContractDetailsCollectionViewCell
            let model = self.userInfo[indexPath.row]
            cell.titleLabel.text = model.title
            cell.subtitleLabel.text = model.describe
            cell.titleLabel.textAlignment = .left
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self), for: indexPath) as! DDCRadioButtonCollectionViewCell
            let model: DDCCheckBoxModel?
            if indexPath.section == 1 {
                model = self.stores![indexPath.row]
            } else {
                model = self.saleTypes[indexPath.row]
            }
            cell.configureCell(model: model!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0,
            kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self), for: indexPath) as! DDCContractHeaderFooterView
            view.titleLabel.text = "请继续补充订单／合同信息"
            return view
        } else if indexPath.section > 0,
            kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
            if indexPath.section == 1 {
                headerView.titleLabel.configure(title: "当前所在门店", isRequired: true)
            } else {
                headerView.titleLabel.configure(title: "销售类型", isRequired: true)
            }
            return headerView
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
}

extension DDCSelectStoreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 20)
        }
        return CGSize.init(width: DDCAppConfig.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: DDCAppConfig.kLeftMargin, bottom: 0, right: DDCAppConfig.kLeftMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 70.0)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize.init(width: DDCAppConfig.width, height: 50.0)
    }
    
}

extension DDCSelectStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            var store: DDCCheckBoxModel?
            for index in 0...((self.stores?.count)! - 1) {
                store = self.stores![index]
                if indexPath.row == index {
                    store!.isSelected = true
                    selectedStore = store
                } else {
                    store!.isSelected = false
                }
            }
        } else if indexPath.section == 2 {
            var type: DDCCheckBoxModel?
            for index in 0...(self.saleTypes.count - 1) {
                type = self.saleTypes[index]
                if indexPath.row == index {
                    type!.isSelected = true
                    selectedType = index
                } else {
                    type!.isSelected = false
                }
            }
        }
        if selectedStore != nil && selectedType != nil {
            self.bottomBar.buttonArray![1].isEnabled = true
            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
        }
        self.collectionView.reloadSections([indexPath.section])
    }
    
}
