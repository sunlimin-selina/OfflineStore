//
//  DDCPaymentViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCPaymentViewController: DDCChildContractViewController {
    var payments: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "微信支付", discription: "", isSelected: false) ,DDCCheckBoxModel.init(id: nil, title: "支付宝支付", discription: "", isSelected: false),DDCCheckBoxModel.init(id: nil, title: "已完成线下支付", discription: "(请在确认收到款项后勾选此项)", isSelected: false)]
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCRadioButtonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self))
        _collectionView.register(DDCContractDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self))
        _collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
        _collectionView.register(DDCSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderView.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "提交", style: .highlighted, handler: {
            //            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
//        self.getStoresAndContractTypes()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
}

// MARK: Private
extension DDCPaymentViewController {
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
    
}

// MARK: API
extension DDCPaymentViewController {
    
    func getStoresAndContractTypes() {
        DDCTools.showHUD(view: self.view)
        DDCStoreAndContractTypeAPIManager.getStoresAndContractTypes(successHandler: { (array) in
            DDCTools.hideHUD()
            self.payments = DDCCheckBoxModel.modelTransformation(models: array)
            self.collectionView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK: Action
extension DDCPaymentViewController {
    
    func didSelectRadioButton(sender: UIButton) {
        
    }
}

// MARK: UICollectionViewDelegate
extension DDCPaymentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self), for: indexPath) as! DDCRadioButtonCollectionViewCell
            let model: DDCCheckBoxModel = self.payments[indexPath.row]
            cell.configureCell(model: model)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderView.self), for: indexPath) as! DDCSectionHeaderView
            headerView.titleLabel.configure(title: "请选择支付方式", isRequired: false)
            return headerView
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
}

extension DDCPaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 500, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: (screen.width - 500)/2, bottom: 0, right: (screen.width - 500)/2)
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
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 500, height: 50.0)
    }
    
}

extension DDCPaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            var store: DDCCheckBoxModel?
        for index in 0...(self.payments.count - 1) {
                store = self.payments[index]
                if indexPath.row == index {
                    store!.isSelected = true
                } else {
                    store!.isSelected = false
                }
            }
        self.collectionView.reloadSections([indexPath.section])
    }
    
}
