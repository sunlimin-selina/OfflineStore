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
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "创建新合同", style: .normal, handler: {
            let viewController : DDCCreateContractViewController = DDCCreateContractViewController.init(progress: .DDCContractProgressAddPhoneNumber, model: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        return _bottomBar
    }()
    
    private lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView()
        tableView.register(DDCContractListTableViewCell.self, forCellReuseIdentifier: String(describing: DDCContractListTableViewCell.self))
        tableView.rowHeight = 100.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private lazy var tableHeaderView : DDCContractListTableHeaderView = {
        let tableHeaderView : DDCContractListTableHeaderView = DDCContractListTableHeaderView.init(frame: CGRect.zero)
        
        return tableHeaderView
    }()
    
    private lazy var user : DDCUserModel? = {
        return DDCStore.sharedStore().user
    }()
    
//    private var contractArray : Array<DDCContractDetailsModel>?
//    private var blankView : DDCButtonView?
    private var orderingUpdate : ((_ newOrdering: String) -> Void)?
    private var page : UInt = 0
    private var status : DDCContractStatus = .all

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightItem = UIBarButtonItem.init(title: "退出帐号", style: .plain, target: self, action: #selector(rightNaviBtnPressed))
        rightItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightItem
        
        //self.reloadPage()
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
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableHeaderView.snp_bottomMargin)
            make.left.right.bottom.equalTo(self.view)
        }
        
        let kBarHeight : CGFloat = 60.0
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-kBarHeight)
        })
        
    }
    
    @objc func rightNaviBtnPressed() {
        weak var weakSelf = self
        let alertController : UIAlertController = UIAlertController.init(title: "你确定要登出吗？", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            DDCStore.sharedStore().user = nil
            weakSelf?.login()
        }))
        alertController.addAction(UIAlertAction.init(title: "取消", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadPage() {
        if self.user != nil {
//            self.view.profileView.name = self.user.name
//            self.view.profileView.imgUrlStr = self.user.imgUrlStr
//            [self loadContractList]
        } else {
            self.login()
        }
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
        weak var weakSelf = self
        var blockStatus = status
        
        guard self.user != nil else {
            DDCLoginRegisterViewController.loginWithTarget(targetController: self) { (success) in
                if success {
                    weakSelf?.dismiss(animated: true, completion: {
                        if ((weakSelf!.orderingUpdate) != nil) {
                            blockStatus = .all
                            // 请求后台
//
//                            [weakSelf loadContractListWithStatus:blockStatus completionHandler:^(BOOL success) {
//                                // 更新UI
//                                weakSelf.orderingUpdate(DDCContractDetailsModel.displayStatusArray[blockStatus])
//                                }]
                        }
                    })
                }
            }
            return
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractListViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractListTableViewCell.self), for: indexPath)) as! DDCContractListTableViewCell
        
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

// MARK: API
extension DDCContractListViewController {
    func loadContractList() {
        self.loadContractListWithStatus(status: self.status, completionHandler: nil)
    }
    
    func loadContractListWithStatus(status: DDCContractStatus,completionHandler:((_ success: Bool) -> Void)?) {
        DDCTools.showHUD(view: self.view, animated: true)
        if status != self.status {
            self.page = 0
        }
        
        
    }
}
