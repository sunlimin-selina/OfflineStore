//
//  DDCContractDetailsViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractDetailsViewController: UIViewController {
    struct Constants {
        static let kDDCContractDetailCellIdentifier = "detailCell"
    }
    
    public var detailsID: Int?
    
    private lazy var barBackgroundView : DDCBarBackgroundView = {
        let barBackgroundView : DDCBarBackgroundView = DDCBarBackgroundView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 54 * 2, height: UIScreen.main.bounds.height - 64 - 32))
        barBackgroundView.tableView.delegate = self as? UITableViewDelegate
        barBackgroundView.tableView.dataSource = self as? UITableViewDataSource
        barBackgroundView.tableView.separatorStyle = .none
        barBackgroundView.tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: String(describing: DDCContractDetailsCell.self))
        return barBackgroundView
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

        self.view.addSubview(self.barBackgroundView)
        self.setupViewConstraints()
        self.title = "合同详情"
        self.getData()
    }
    
    // MARK: Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
  
}

// MARK: Private
extension DDCContractDetailsViewController {
    
    private func setupViewConstraints() {
        self.barBackgroundView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(32 + 64)
            make.left.equalTo(self.view).offset(54)
            make.right.equalTo(self.view).offset(-54)
            make.bottom.equalTo(self.view)
        })
    }
    
    func reloadData() {
        
    }
    
    func getData() {
        DDCTools.showHUD(view: self.view)
        
        weak var weakSelf = self
        if let detailId = self.detailsID {
            DDCContractDetailsAPIManager.fetchContractDetails(detailId: detailId, successHandler: { (dictionary) in
                
            }) { (error) in
                
            }
        }

    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractDetailsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.barBackgroundView.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractDetailsCell.self), for: indexPath)) as! DDCContractDetailsCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        return headerView
    }
}
