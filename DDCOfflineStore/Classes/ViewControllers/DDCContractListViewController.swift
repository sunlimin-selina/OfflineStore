//
//  DDCContractListViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

struct Constants {
    static let kDDCContractListCellIdentifier = "cell"
}

class DDCContractListViewController: UIViewController {
    private lazy var bottomBar : DDCBottomBar = {
        let bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.zero, handler: {
            let viewController : DDCCreateContractViewController = DDCCreateContractViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        })

        return bottomBar;
    }()
    
    private lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView()
        tableView.register(DDCContractListTableViewCell.self, forCellReuseIdentifier: Constants.kDDCContractListCellIdentifier)
        tableView.rowHeight = 100.0;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private lazy var tableHeaderView : DDCContractListTableHeaderView = {
        let tableHeaderView : DDCContractListTableHeaderView = DDCContractListTableHeaderView()
        
        return tableHeaderView
    }()
    
    private lazy var user : DDCUserModel = {
        return DDCStore.sharedStore().user
    }()
    
//    var contractListView : DDCContractListView?

//    private var contractArray : Array<DDCContractDetailsModel>?
//    private var blankView : DDCButtonView?
////    private var orderingUpdate : OrderingUpdateCallback?
    private var page : UInt = 0
    private var status : DDCContractStatus = .DDCContractStatusAll

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightItem = UIBarButtonItem.init(title: "退出帐号", style: .plain, target: self, action: nil)
        rightItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.view.addSubview(self.tableHeaderView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.title = "课程管家"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
}

// MARK: private
extension DDCContractListViewController {
    private func setupViewConstraints() {
        self.tableHeaderView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(250)
            make.bottom.equalTo(self.tableView.snp_topMargin)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableHeaderView.snp_bottomMargin)
            make.left.right.bottom.equalTo(self.view)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(50)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-50)
        })
        
    }
}

// MARK: API
extension DDCContractListViewController {
    func getData() {
        DDCContractListAPIManager.downloadContractListForPage(page: self.page , status: self.status.rawValue , successHandler: { (Any) in
            
        }) { (Any) in
            
        }
    }
    
    func login() {
        if self.user != nil {
            
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractListViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: Constants.kDDCContractListCellIdentifier, for: indexPath)) as! DDCContractListTableViewCell;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController : DDCContractDetailsViewController = DDCContractDetailsViewController.init(detailsID: "")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label : UILabel = UILabel()
        label.text = "我创建的合同"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.frame = CGRect.init(x: 20, y: 10, width: 400, height: 40)
        headerView.addSubview(label)
        return headerView
    }
}

