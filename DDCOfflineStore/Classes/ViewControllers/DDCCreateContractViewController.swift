//
//  DDCCreateContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCreateContractViewController: UITableViewController {
    
    enum DDCContractProgress : UInt {
        case DDCContractProgressAddPhoneNumber//添加手机号
        case DDCContractProgressEditClientInformation//客户信息
        case DDCContractProgressAddContractInformation//创建新合同
        case DDCContractProgressFinishContract//创建成功
    }
    
    var progress: DDCContractProgress?
    var model: DDCContractModel?
    var subViewControllers: Array<UIViewController>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_back"), style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(self.tableHeaderView)
//        self.view.addSubview(self.tableView)
//        self.view.addSubview(self.bottomBar)
//        self.setupViewConstraints()
//
        self.title = "创建新合同"
        
    }
    
    func createContract(progress: DDCContractProgress, model: DDCContractModel){
        self.progress = progress
        self.model = model
        self.createChildViewControllers()
    }
    
    func createChildViewControllers() {
        let customerViewController: DDCEditClientInfoViewController  = DDCEditClientInfoViewController()
//        customerViewController.index = 0
//        customerViewController.delegate = self
        self.subViewControllers?.append(customerViewController)

        let storeViewController : DDCSelectStoreViewController = DDCSelectStoreViewController()
        //        storeViewController.index = 1
        //        storeViewController.delegate = self
        self.subViewControllers?.append(storeViewController)
        
        let contractViewController : DDCAddContractInfoViewController = DDCAddContractInfoViewController()
        //        storeViewController.index = 2
        //        storeViewController.delegate = self
        self.subViewControllers?.append(contractViewController)
        
        let paymentViewController : DDCPaymentViewController = DDCPaymentViewController()
        //        storeViewController.index = 3
        //        storeViewController.delegate = self
        self.subViewControllers?.append(paymentViewController)

        if let model = self.model {
//            self.subViewControllers![self.progress].model = model
        }
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
