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
    var userInfo: [DDCContractDetailsViewModel] = DDCContractDetailsViewModelFactory.integrateUserData(category: nil)
    var saleTypes: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "体验课订单", isSelected: false),DDCCheckBoxModel.init(id: nil, title: "普通合同", isSelected: false),DDCCheckBoxModel.init(id: nil, title: "团体合同", isSelected: false)]
    
    lazy var tableView: UITableView! = {        
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.register(DDCRadioButtonTableViewCell.self, forCellReuseIdentifier: String(describing: DDCRadioButtonTableViewCell.self))
        _tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: String(describing: DDCContractDetailsCell.self))
        _tableView.register(DDCSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DDCSectionHeaderView.self))
        _tableView.rowHeight = 80.0
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.isUserInteractionEnabled = true
        _tableView.separatorColor = UIColor.white
        _tableView.backgroundColor = UIColor.white
        return _tableView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            //            self.forwardNextPage()
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
//            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.getStoresAndContractTypes()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
}

// MARK: Private
extension DDCSelectStoreViewController {
    func setupViewConstraints() {
        self.tableView.snp.makeConstraints { (make) in
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

// MARK: UICollectionViewDelegate
extension DDCSelectStoreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.userInfo.count
        } else if section == 1 {
            return self.stores!.count
        }
        return self.saleTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractDetailsCell.self), for: indexPath)) as! DDCContractDetailsCell
            let model = self.userInfo[indexPath.row]
            cell.titleLabel.text = model.title
            cell.subtitleLabel.text = model.describe
            cell.titleLabel.textAlignment = .left
            return cell
        } else {
            let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCRadioButtonTableViewCell.self), for: indexPath)) as! DDCRadioButtonTableViewCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCSectionHeaderView.self))) as! DDCSectionHeaderView
        if section == 1 {
            headerView.titleLabel.configure(title: "当前所在门店", isRequired: true)
        } else {
            headerView.titleLabel.configure(title: "销售类型", isRequired: true)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = (self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCSectionHeaderView.self))) as! DDCSectionHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            var store: DDCCheckBoxModel?
            for index in 0...((self.stores?.count)! - 1) {
                store = self.stores![index]
                if indexPath.row == index {
                    store!.isSelected = true
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
                } else {
                    type!.isSelected = false
                }
            }
        }
        self.tableView.reloadSections([indexPath.section], with: .automatic)
    }
}

// MARK: API
extension DDCSelectStoreViewController {
    
    func getStoresAndContractTypes() {
        DDCTools.showHUD(view: self.view)
        DDCStoreAndContractTypeAPIManager.getStoresAndContractTypes(successHandler: { (array) in
            DDCTools.hideHUD()
            self.stores = DDCCheckBoxModel.modelTransformation(models: array)
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK: Action
extension DDCSelectStoreViewController {
    
    func didSelectRadioButton(sender: UIButton) {
        
    }
}
