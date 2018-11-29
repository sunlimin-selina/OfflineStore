//
//  DDCContractDetailsViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

typealias Categorys = (model: DDCContractModel?, channels: [DDCChannelModel]?, stores: [DDCStoreModel]?, package: Package)

class DDCContractDetailsViewController: UIViewController {
    struct constant{
        static let kMargin: CGFloat = 54.0
    }
    
    public var detailsID: Int?
    var modelArray: [DDCContractDetailsViewModel]? = Array()
    var model: DDCContractDetailModel?
    
    private lazy var barBackgroundView: DDCBarBackgroundView = {
        let _barBackgroundView: DDCBarBackgroundView = DDCBarBackgroundView.init(frame: CGRect.init(x: constant.kMargin, y: screen.navigationBarHeight + screen.statusBarHeight + 32, width: screen.width - constant.kMargin * 2, height: screen.height - constant.kMargin - 32))
        _barBackgroundView.tableView.delegate = self
        _barBackgroundView.tableView.dataSource = self
        _barBackgroundView.tableView.separatorStyle = .none
        _barBackgroundView.tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: String(describing: DDCContractDetailsCell.self))
        _barBackgroundView.tableView.register(DDCContractDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DDCContractDetailsHeaderView.self))
        return _barBackgroundView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: constant.kMargin, y: screen.height - DDCAppConfig.kBarHeight, width: screen.width - constant.kMargin * 2, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "取消支付", style: .forbidden, handler: {
            let alertController: UIAlertController = UIAlertController.init(title: "您确定要取消当前订单吗？", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "取消订单", style: .default, handler: { (action) in
                self.cancelContract()
            }))
            alertController.addAction(UIAlertAction.init(title: "再想想", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "去支付", style: .highlighted, handler: {
            let viewController: DDCCreateContractViewController = DDCCreateContractViewController.init(toPaymentView: DDCContractDetailsViewModelFactory.convertModel(model: self.model!))
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        return _bottomBar
    }()
    
    init(detailsID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.detailsID = detailsID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_back"), style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DDCColor.complementaryColor.backgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.barBackgroundView)
        self.title = "订单详情"
        self.getData()
    }
    
    // MARK: Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
  
}

// MARK: Private
extension DDCContractDetailsViewController {
    
    func getData() {
        DDCTools.showHUD(view: self.view)
        
        weak var weakSelf = self
        if let detailId = self.detailsID {
            DDCContractDetailsAPIManager.getContractDetails(detailId: detailId, successHandler: { (response) in
                DDCTools.hideHUD()
                if let _response = response {
                    weakSelf!.model = _response
                    weakSelf!.modelArray = DDCContractDetailsViewModelFactory.integrateData(model: _response)
                    if weakSelf!.model!.tradeStatus == DDCContractStatus.inComplete {
                        weakSelf!.view.addSubview(weakSelf!.bottomBar)
                    }
                }
                weakSelf!.barBackgroundView.tableView.reloadData()

            }, failHandler: { (error) in
                DDCTools.hideHUD()
            })
        }

    }
    
    func cancelContract() {
        DDCTools.showHUD(view: self.view)
        
        weak var weakSelf = self
        DDCContractDetailsAPIManager.cancelContract(model: self.model!, successHandler: { (success) in
            if success {
                self.view.makeDDCToast(message: "订单已取消", image: UIImage.init(named: "addCar_icon_fail")!)
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractDetailsViewController: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.barBackgroundView.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractDetailsCell.self), for: indexPath)) as! DDCContractDetailsCell
        cell.selectionStyle = .none
        let model: DDCContractDetailsViewModel = self.modelArray![indexPath.row]
        cell.titleLabel.text = model.title
        cell.subtitleLabel.text = model.describe
        cell.subtitleLabel.textColor = model.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCContractDetailsHeaderView.self))) as! DDCContractDetailsHeaderView
        headerView.status = self.model?.tradeStatus
        return headerView
    }
}
