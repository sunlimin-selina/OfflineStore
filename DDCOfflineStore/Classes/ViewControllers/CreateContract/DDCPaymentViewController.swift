//
//  DDCPaymentViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCPaymentViewController: DDCChildContractViewController {
    var payments: [DDCCheckBoxModel] = Array()
    var result: (online: DDCPaymentOptionModel?, offline: DDCPaymentOptionModel?)
    var onlinePayment: DDCOnlinePaymentOptionModel?
    var pickedSection: Int = 999
    lazy var paymentUpdateChecker: DDCPaymentUpdateChecker = {
        let paymentUpdateChecker: DDCPaymentUpdateChecker = DDCPaymentUpdateChecker()
        paymentUpdateChecker.delegate = self
        return paymentUpdateChecker
    }()
    var freeOrder: Bool {
        get {
            return (self.model!.specs?.costPrice == nil || self.model!.specs?.costPrice == 0) && (self.model!.contractPrice == nil || self.model!.contractPrice == 0)
        }
    }
    
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCRadioButtonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self))
        _collectionView.register(DDCPaymentQRCodeImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCPaymentQRCodeImageCollectionViewCell.self))
        _collectionView.register(DDCRadioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self))
        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 0.0, y: 0, width: screen.width, height: DDCAppConfig.kBarHeight))
        if self.freeOrder { //0元订单
            _bottomBar.addButton(button:DDCBarButton.init(title: "完成", style: .highlighted, handler: {
                let viewController: DDCFinishedContractViewController = DDCFinishedContractViewController.init(model: self.model!)
                self.navigationController?.pushViewController(viewController, animated: true)
            }))
        } else {
            _bottomBar.addButton(button:DDCBarButton.init(title: "提交", style: .highlighted, handler: {
                self.commitForm()
            }))
        }

        return _bottomBar
    }()
    
    lazy var images: Array<String> = ["icon_pay_alipay", "icon_pay_wechat", "icon_pay_offline"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //0元订单
        if self.freeOrder {
            DDCDefaultView.sharedView().showPromptView(view: self.view, title: "该合同无需付款，请点击‘完成’直接提交", image: UIImage.init(named: "chuangjianxindingdan_queshengtu")!, topPadding: 350)
            self.view.addSubview(self.bottomBar)
            self.setupViewConstraints()
        } else { //普通订单
            self.view.addSubview(self.collectionView)
            self.view.addSubview(self.bottomBar)
            self.setupViewConstraints()
            self.getPaymentOptions()
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
}

// MARK: Private
extension DDCPaymentViewController {
    func setupViewConstraints() {
        if  !self.freeOrder {
            self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-DDCAppConfig.kBarHeight)
            }
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })

    }
    
    func integratePaymentData() -> [DDCCheckBoxModel]{
        var array: [DDCCheckBoxModel] = Array()

        for item in (self.result.online?.channels)! {
            let model: DDCCheckBoxModel = DDCCheckBoxModel.init(id: nil, title: item.title, discription: "", isSelected: false) 
            array.append(model)
        }
        
        array.append(DDCCheckBoxModel.init(id: nil, title: "已完成线下支付", discription: "(请在确认收到款项后勾选此项)", isSelected: false))
        return array
    }
}

// MARK: API
extension DDCPaymentViewController {
    
    func getPaymentOptions() {
        guard self.model?.customer?.mobile != nil else {
            return
        }
        DDCTools.showHUD(view: self.view)
        DDCPaymentOptionsAPIManager.paymentOption(phone: (self.model?.customer?.mobile)!, successHandler: { (tuple) in
            if let _tuple = tuple {
                self.result = _tuple
                self.payments = self.integratePaymentData()
                let contractModel: DDCOnlinePaymentOptionModel = DDCOnlinePaymentOptionModel()
                contractModel.contractNo = self.model?.code
                self.collectionView.reloadData()
                self.paymentUpdateChecker.startChecking(paymentModel: contractModel)
            }
            DDCTools.hideHUD()
        }, failHandler: { (error) in
            DDCTools.hideHUD()
        })
        
    }
    
    func createPaymentOption(payment: DDCPaymentItemModel?) {
        DDCTools.showHUD(view: self.view)
        if let _payment: DDCPaymentItemModel = payment {
            DDCPaymentOptionsAPIManager.createPaymentOption(model: self.model, payChannel: _payment.code!, payStyle: self.pickedSection == 3 ? 2 : 1, successHandler: { (model) in //支付渠道类型（1, "在线支付" 2, "线下支付"）
                DDCTools.hideHUD()
                if let _model = model {
                    self.onlinePayment = _model
                    self.collectionView.reloadData()
                }
            }) { (error) in
                DDCTools.hideHUD()
            }
        }
    }
    
}

// MARK: Action
extension DDCPaymentViewController {
    
    func commitForm() {
        weak var weakSelf = self
        let alertController: UIAlertController = UIAlertController.init(title: "确定客户已完成线下支付吗？", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            let viewController: DDCFinishedContractViewController = DDCFinishedContractViewController.init(model: weakSelf!.model!)
            weakSelf!.navigationController?.pushViewController(viewController, animated: true)
        }))
        alertController.addAction(UIAlertAction.init(title: "取消", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegate
extension DDCPaymentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.payments.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3, self.pickedSection == 3,
            let offlineOptions = self.result.offline?.channels {
            return offlineOptions.count
        } else if self.pickedSection < 3 && self.onlinePayment != nil {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 3, self.pickedSection == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCRadioButtonCollectionViewCell.self), for: indexPath) as! DDCRadioButtonCollectionViewCell
            let model = self.result.offline?.channels![indexPath.item]
            cell.configureCell(model: model!)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCPaymentQRCodeImageCollectionViewCell.self), for: indexPath) as! DDCPaymentQRCodeImageCollectionViewCell
            let model: DDCOnlinePaymentOptionModel = self.onlinePayment!
            let price: String = ((self.model!.specs?.costPrice != nil) ? "\(self.model!.specs?.costPrice! )" : "\(self.model!.contractPrice!)")
            cell.configureCell(QRCodeURLString: model.qr_code ?? "", price: price)
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
                
                var image: UIImage = UIImage.init(named: "icon_pay_offline")!
                if model.title == "支付宝" {
                    image = UIImage.init(named: "icon_pay_alipay")!
                } else if model.title == "微信" {
                    image = UIImage.init(named: "icon_pay_wechat")!
                }
                headerView.radioButton.imageView.image = image
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
            for index in 0...((self.result.offline!.channels!.count) - 1) {
                item = self.result.offline!.channels![index]
                if indexPath.item == index {
                    item!.isSelected = true
                    self.createPaymentOption(payment: (self.result.offline?.channels![index])!)
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
        if self.pickedSection != 3 {
            self.createPaymentOption(payment: (self.result.online?.channels![index])!)
        }
        self.collectionView.reloadData()
    }
}


extension DDCPaymentViewController: DDCPaymentUpdateCheckerDelegate {
    func payment(updateChecker: DDCPaymentUpdateChecker, paymentOption: DDCOnlinePaymentOptionModel, status: DDCPaymentStatus) {
        switch status {
        case .paid:
            let viewController: DDCFinishedContractViewController = DDCFinishedContractViewController.init(model: self.model!)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .overdue:
            do {
                self.createPaymentOption(payment: (self.result.online?.channels![self.pickedSection])!)
            }
        default:
            self.view.makeDDCToast(message: "支付失败了", image: UIImage.init(named: "addCar_icon_fail")!)

        }
    }
    
    
}
