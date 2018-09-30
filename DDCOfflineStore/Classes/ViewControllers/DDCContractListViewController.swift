//
//  DDCContractListViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

struct Constants {
    static let kDDCContractListCellIdentifier = "cell"
}

class DDCContractListViewController: UIViewController {
    private lazy var bottomBar : DDCBottomBar = {
        let bottomBar : DDCBottomBar = DDCBottomBar()
        return bottomBar;
    }()
    
    private lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView()
        tableView.register(DDCContractListTableViewCell.self, forCellReuseIdentifier: Constants.kDDCContractListCellIdentifier)
        tableView.rowHeight = 100.0;
        tableView.delegate = self;
        tableView.dataSource = self;
        return tableView
    }()
    
    private lazy var tableHeaderView : DDCContractListTableHeaderView = {
        let tableHeaderView : DDCContractListTableHeaderView = DDCContractListTableHeaderView()
        
        return tableHeaderView
    }()
    
//    var contractListView : DDCContractListView?
    
//    private var user : DDCUserModel?
//    private var contractArray : Array<DDCContractDetailsModel>?
//    private var blankView : DDCButtonView?
////    private var orderingUpdate : OrderingUpdateCallback?
//    private var page : UInt?
//    private var status : DDCContractStatus?

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
        self.view.addSubview(self.tableHeaderView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        
        self.title = "课程管家"
        
        
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

extension UIImage {
    class func imageWithColor(color: UIColor,width: CGFloat = 1, height: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
