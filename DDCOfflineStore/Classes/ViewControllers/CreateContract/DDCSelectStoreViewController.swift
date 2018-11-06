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
    var stores: [DDCStoreModel]?  = Array()

    lazy var tableView: UITableView! = {        
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.register(DDCCheckBoxTableViewCell.self, forCellReuseIdentifier: String(describing: DDCCheckBoxTableViewCell.self))
//        _tableView.register(DDCOrderingHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DDCOrderingHeaderView.self))
        _tableView.rowHeight = 80.0
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.isUserInteractionEnabled = true
        _tableView.separatorColor = UIColor.white
        return _tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.setupViewConstraints()
        self.getStoresAndContractTypes()
    }
    
}

// MARK: Private
extension DDCSelectStoreViewController {
    func setupViewConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-DDCAppConfig.kBarHeight)
        }
    }
    
}

// MARK: UICollectionViewDelegate
extension DDCSelectStoreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCCheckBoxTableViewCell.self), for: indexPath)) as! DDCCheckBoxTableViewCell
        let cellControl = DDCCheckBoxTableViewCellControl.init(cell: cell)
        cellControl.setData(data: self.stores!, cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DDCCheckBoxTableViewCellControl.cellHeight()
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return DDCCheckBoxTableViewCellControl.cellHeight()
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = (self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCOrderingHeaderView.self))) as! DDCOrderingHeaderView
//        return headerView
//    }

}

// MARK: API
extension DDCSelectStoreViewController {
    
    func getStoresAndContractTypes() {
        DDCTools.showHUD(view: self.view)
        DDCStoreAndContractTypeAPIManager.getStoresAndContractTypes(successHandler: { (array) in
            DDCTools.hideHUD()
            self.stores = array
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
}
