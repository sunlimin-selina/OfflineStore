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

    public var detailsID: Int?
    var modelArray : [DDCContractDetailsViewModel]? = Array()
    var categorys : Categorys
    
    private lazy var barBackgroundView : DDCBarBackgroundView = {
        let barBackgroundView : DDCBarBackgroundView = DDCBarBackgroundView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 54 * 2, height: UIScreen.main.bounds.height - 64 - 32))
        barBackgroundView.tableView.delegate = self
        barBackgroundView.tableView.dataSource = self
        barBackgroundView.tableView.separatorStyle = .none
        barBackgroundView.tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: String(describing: DDCContractDetailsCell.self))
        barBackgroundView.tableView.register(DDCContractDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DDCContractDetailsHeaderView.self))
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
            DDCContractDetailsAPIManager.fetchContractDetails(detailId: detailId, successHandler: { (response) in
                DDCTools.hideHUD()
                if let _response = response {
                    weakSelf!.categorys = _response
                    weakSelf!.modelArray = DDCContractDetailsViewModelFactory.integrateData(category: _response)
                }
                weakSelf!.barBackgroundView.tableView.reloadData()
            }) { (error) in
                DDCTools.hideHUD()

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DDCContractDetailsHeaderView.self))) as! DDCContractDetailsHeaderView
        headerView.status = self.categorys.model?.status
        return headerView
    }
}
