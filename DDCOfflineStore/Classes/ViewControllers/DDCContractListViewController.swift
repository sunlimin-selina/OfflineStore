//
//  DDCContractListViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

struct Constants {
    static let kDDCContractListCellIdentifier = "cell"
    static let kDefault: String = "contractArray"
}

class DDCContractListViewController: UIViewController {
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "创建新订单", style: .highlighted, handler: { [unowned self] in
            let viewController: DDCCreateContractViewController = DDCCreateContractViewController.init(progress: .editClientInformation, model: DDCContractModel())
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        return _bottomBar
    }()
    
    private lazy var tableView: UITableView = {
        let _tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.register(DDCContractListTableViewCell.self, forCellReuseIdentifier: String(describing: DDCContractListTableViewCell.self))
        _tableView.register(DDCContractListGroupTableViewCell.self, forCellReuseIdentifier: String(describing: DDCContractListGroupTableViewCell.self))
        _tableView.register(DDCOrderingHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DDCOrderingHeaderView.self))
        _tableView.rowHeight = 112.0
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.isUserInteractionEnabled = true
        _tableView.separatorColor = UIColor.clear
        _tableView.layer.cornerRadius = 5
        //设置上拉加载的footer动画
        let footer = MJRefreshAutoGifFooter { [unowned self] in
            self.getContractList()
        }
        footer?.setImages([UIImage.init(named: "load1") as Any,UIImage.init(named: "load2") as Any,UIImage.init(named: "load3") as Any,UIImage.init(named: "load4") as Any,UIImage.init(named: "load5") as Any,UIImage.init(named: "load6") as Any], for: .refreshing)
        footer?.setTitle("正在帮你加载数据...", for: .refreshing)
        footer?.setTitle("松开立即加载更多数据", for: .pulling)
        footer?.setTitle("上拉可以加载更多数据", for: .idle)
        _tableView.mj_footer = footer
        return _tableView
    }()
    
    private lazy var contractTableHeaderView: DDCContractListTableHeaderView = {
        let _contractTableHeaderView: DDCContractListTableHeaderView = DDCContractListTableHeaderView.init(frame: CGRect.zero)
        
        return _contractTableHeaderView
    }()
    
    private var user: DDCUserModel? {
        get {
            return DDCStore.sharedStore().user
        }
    }
    
    private var contractArray: NSMutableArray? = NSMutableArray()
    private var orderingUpdate: ((_ newOrdering: String) -> Void)?
    private var page: UInt = 0
    private var status: DDCContractStatus = .all
    private var type: DDCContractType = .none

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22.0, weight: .medium)]
        
        let rightItem = UIBarButtonItem.init(title: "登出帐号", style: .plain, target: self, action: #selector(rightNaviBtnPressed))
        rightItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightItem
        self.page = 0

        self.reloadPage()
        
        //新增强制更新
        DDCVersionCheckAPIManager.checkVersion(successHandler: { [unowned self] (version) in
            if let _version: String = version {
                let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                if _version != currentVersion{
                    self.alertUpdate()
                }
            }
        }) { (error) in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.contractTableHeaderView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.title = "课程管家"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
   
}

// MARK: private
extension DDCContractListViewController {
    private func setupViewConstraints() {
        
        self.contractTableHeaderView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(250)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contractTableHeaderView.snp_bottomMargin)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-DDCAppConfig.kBarHeight)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })
        
    }
    
    @objc func rightNaviBtnPressed() {
        let alertController: UIAlertController = UIAlertController.init(title: "您确定要登出当前账号吗？", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "退出", style: .default, handler: {[unowned self] (action) in
            DDCStore.sharedStore().user = nil
            UserDefaults.standard.removeObject(forKey: "DDCUser")
            UserDefaults.standard.synchronize()
            self.login()
        }))
        alertController.addAction(UIAlertAction.init(title: "否", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func reloadPage() {
        if self.user != nil {
            self.contractTableHeaderView.userName.text = self.user!.name
            self.contractTableHeaderView.portraitView.image = (self.user!.imageUrl != "") ? UIImage.init(named: self.user!.imageUrl!): UIImage.init(named: "Personal_head")
            
            self.getContractList()
        } else {
            self.login()
        }
    }
    
    func alertUpdate() {
        let alertController: UIAlertController = UIAlertController.init(title: "需要更新版本", message: "请更新版本", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "去更新", style: .default, handler: { [unowned self] (action) in
            let url: URL = URL.init(string: DDCAPIManager.DDC_Update_Url)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
            self.alertUpdate()
        }))

        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: API
extension DDCContractListViewController {
    func getData() {
        DDCContractListAPIManager.getContractList(page: 0, status: 0, type: 0, successHandler: { [unowned self] (contractList) in
            if (contractList.count >= 10) {
                self.page += 1
            }
            self.contractArray?.addObjects(from: contractList)
            DDCTools.hideHUD()
            self.tableView.reloadData()
        }) { [unowned self] (error) in
            DDCTools.hideHUD()
            
            if error.count != 0 {
                self.view.makeDDCToast(message: error, image: UIImage.init(named: "addCar_icon_fail")!)
            }
        }
    }
    
    func login() {
        var blockStatus = status
        
        guard self.user != nil else {
            DDCLoginRegisterViewController.login(targetController: self) { [unowned self] (success) in
                if success {
                    self.dismiss(animated: true, completion: {
                        blockStatus = .all
                        // 请求后台
                        self.loadContractList(status: blockStatus, type: self.type, completionHandler: { (success) in
                        })
                    })
                }
            }
            return
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractListViewController: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contractArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: DDCContractListModel = self.contractArray![indexPath.row] as! DDCContractListModel
        
        if model.type == DDCContractType.personalRegular || model.type == DDCContractType.personalSample {
            let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractListTableViewCell.self), for: indexPath)) as! DDCContractListTableViewCell
            cell.contentView.backgroundColor = (indexPath.row % 2 == 0) ? DDCColor.complementaryColor.backgroundColor: UIColor.white
            cell.configureCell(model: model)
            return cell
        } else {
            let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractListGroupTableViewCell.self), for: indexPath)) as! DDCContractListGroupTableViewCell
            cell.contentView.backgroundColor = (indexPath.row % 2 == 0) ? DDCColor.complementaryColor.backgroundColor: UIColor.white
            cell.configureCell(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: DDCContractListModel = self.contractArray![indexPath.item] as! DDCContractListModel
        guard model.contractId != nil else {
            return
        }
        let viewController: DDCContractDetailsViewController = DDCContractDetailsViewController.init(detailsID: model.code!)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCOrderingHeaderView.self))) as! DDCOrderingHeaderView
        headerView.delegate = self
        return headerView
    }
}

// MARK: API
extension DDCContractListViewController {
    @objc func getContractList() {
        self.loadContractList(status: self.status, type: self.type, completionHandler: nil)
    }
    
    func loadContractList(status: DDCContractStatus, type:DDCContractType, completionHandler:((_ success: Bool) -> Void)?) {
        DDCTools.showHUD(view: self.view)
        if status != self.status {
            self.page = 0
        }
        
        DDCDefaultView.sharedView().clear()

        DDCContractListAPIManager.getContractList(page: self.page, status: status.rawValue, type: type.rawValue, successHandler: { [unowned self] (contractList) in
            if (status != self.status) {
                self.contractArray = []
                self.status = status
                self.tableView.mj_footer.isHidden = false
            }
            
            if (self.page == 0)  {
                self.contractArray = []
            }
            
            if (contractList.count < 10)
            {
                self.tableView.mj_footer.isHidden = true
            } else {
                self.tableView.mj_footer.isHidden = false
                self.page += 1
            }
            DDCTools.hideHUD()
            self.contractArray?.addObjects(from: contractList)
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            if self.contractArray == nil || self.contractArray?.count == 0 {
                self.tableView.backgroundView = UIView()
                DDCDefaultView.sharedView().showDefaultView(view: self.tableView.backgroundView!, title: "还没有创建过订单哟！", image: UIImage.init(named: "homepage_queshengtu")!)
            }
            if (completionHandler != nil) {
                completionHandler! (true)
            }
        }) { [unowned self] (error) in
            DDCTools.hideHUD()
            self.tableView.mj_footer.endRefreshing()
            if error.count != 0 {
                self.view.makeDDCToast(message: error, image: UIImage.init(named: "addCar_icon_fail")!)
            }
            if self.contractArray == nil || self.contractArray?.count == 0 {
                self.tableView.mj_footer.isHidden = true
                self.tableView.backgroundView = UIView()
                DDCDefaultView.sharedView().showDefaultView(view: self.tableView.backgroundView!, title: "还没有创建过订单哟！", image: UIImage.init(named: "homepage_queshengtu")!)
            }
            if (completionHandler != nil) {
                completionHandler! (false)
            }
        }
    }
}

extension DDCContractListViewController :DDCOrderingHeaderViewDelegate {

    func headerView(_ headerView: DDCOrderingHeaderView, callback: @escaping (String?) -> Void) {
        var popRect: CGRect = self.tableView .convert(headerView.frame, to: self.view)
        popRect.origin.x = 0
        popRect.size.width = screen.width
        
        self.popOrderingMenu(rect: popRect, callback: callback)
    }
    
    func popOrderingMenu(rect: CGRect, callback: @escaping OrderingUpdateCallback) {
        
        // 弹窗让用户选择筛选
        let viewController: DDCOrderingTableViewController = DDCOrderingTableViewController.init(array: DDCContract.backendStatusArray, rect: rect) { [unowned self] (selected) in
            if let _selected = selected {
                // 获取status值
                let statusArray: NSArray = DDCContract.backendStatusArray as NSArray
                let status: DDCContractStatus = DDCContractStatus(rawValue: UInt(statusArray.index(of: _selected as Any)))!
                let type: DDCContractType = .none//DDCContractType(rawValue: UInt(statusArray.index(of: _selected as Any)))!

                // 关掉弹窗
                self.dismiss(animated: true, completion: {
                    self.loadContractList(status: status, type: type, completionHandler: { (success) in
                        callback(selected)
                    })
                })
            }
            
        }
        
        
//        if let popover = viewController.popoverPresentationController {
//            popover.sourceView = self.tableView
//            popover.sourceRect = rect
//            popover.permittedArrowDirections = []
//            popover.backgroundColor = UIColor.white
//        }
        viewController.view.superview?.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
}

