//
//  DDCCreateContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCCreateContractViewController: UITableViewController {
    
    enum DDCContractProgress {
        case DDCContractProgressAddPhoneNumber//添加手机号
        case DDCContractProgressEditClientInformation//客户信息
        case DDCContractProgressAddContractInformation//创建新合同
        case DDCContractProgressFinishContract//创建成功
    }
    
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
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
