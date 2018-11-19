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
    var result: (wechat: DDCOnlinePaymentOptionModel?, alipay: DDCOnlinePaymentOptionModel?, offline: [DDCPaymentOptionModel]?)
    var pickedSection: Int = 999

    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCRadioButtonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self))
        _collectionView.register(DDCPaymentQRCodeImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCPaymentQRCodeImageCollectionViewCell.self))
        _collectionView.register(DDCRadioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self))
        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        _collectionView.backgroundColor = UIColor.white
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "提交", style: .highlighted, handler: {
            //            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    lazy var images: Array<String> = ["icon_pay_wechat", "icon_pay_alipay", "icon_pay_offline"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.getPaymentOptions()
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
    
    func getPaymentOptions() {
        DDCTools.showHUD(view: self.view)
        DDCPaymentOptionsAPIManager.paymentOptions(contractId: "1414", price: "0.01", successHandler: { (tuple) in
            if let _tuple = tuple {
                self.result = _tuple
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            }
           
            DDCTools.hideHUD()
        }) { (error) in
            DDCTools.hideHUD()
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3, self.pickedSection == 3,
            let offlineOptions = self.result.offline {
            return offlineOptions.count
        } else if self.pickedSection < 3 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 3, self.pickedSection == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self), for: indexPath) as! DDCRadioButtonCollectionViewCell
            let model = self.result.offline![indexPath.item]
            cell.configureCell(model: model)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCPaymentQRCodeImageCollectionViewCell.self), for: indexPath) as! DDCPaymentQRCodeImageCollectionViewCell
            if indexPath.section == 1 {
                let model: DDCOnlinePaymentOptionModel = self.result.wechat!
                cell.configureCell(QRCodeURLString: model.code_url ?? "", price: "2000.0")//self.model?.contractPrice
            } else if indexPath.section == 2 {
                let model: DDCOnlinePaymentOptionModel = self.result.alipay!
                cell.configureCell(QRCodeURLString: model.qr_code ?? "", price: "2000.0")//self.model?.contractPrice
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            if indexPath.section == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
                headerView.titleLabel.configure(title: "请选择支付方式", isRequired: false)
                return headerView
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self), for: indexPath) as! DDCRadioHeaderView
                let model: DDCCheckBoxModel = self.payments[indexPath.section - 1]
                headerView.radioButton.button.setTitle(model.title, for: .normal)
                headerView.radioButton.button.isSelected = model.isSelected
                headerView.radioButton.imageView.image = UIImage.init(named: self.images[indexPath.section - 1] as String)
                headerView.tag = indexPath.section
                headerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(headerSelected(gesture:))))
                return headerView
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
}

extension DDCPaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == self.pickedSection , self.pickedSection != 3 {
            return CGSize.init(width: DDCAppConfig.width - 40 * 2, height: 500)
        } else if indexPath.section == 3 {
            return CGSize.init(width: DDCAppConfig.width - 40 * 2, height: 40)
        }
        return CGSize.init(width: DDCAppConfig.width - 40 * 2, height: 0.01)
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
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 50.0)
        }
        return CGSize.init(width: DDCAppConfig.width, height: 65.0)
    }
    
}

extension DDCPaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            var item: DDCCheckBoxModel?
            for index in 0...((self.result.offline!.count) - 1) {
                item = self.result.offline![index]
                if indexPath.item == index {
                    item!.isSelected = true
                } else {
                    item!.isSelected = false
                }
            }
        }
        self.collectionView.reloadSections([3])
    }
    
}

// MARK: Action
extension DDCPaymentViewController {
    
    @objc func headerSelected(gesture: UITapGestureRecognizer) {
        var offlineOptions: DDCCheckBoxModel?
        let index = (gesture.view?.tag)! - 1
        self.pickedSection = (gesture.view?.tag)!
        for idx in 0...(self.payments.count - 1) {
            offlineOptions = self.payments[idx]
            if index == idx {
                offlineOptions!.isSelected = true
            } else {
                offlineOptions!.isSelected = false
            }
        }
        self.collectionView.reloadData()
    }
}
