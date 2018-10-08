//
//  DDCContractDetailsViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCContractDetailsViewController: UIViewController {
    struct Constants {
        static let kDDCContractDetailCellIdentifier = "detailCell"
    }
    
    public var detailsID: String?
    
    private lazy var barBackgroundView : DDCBarBackgroundView = {
        let barBackgroundView : DDCBarBackgroundView = DDCBarBackgroundView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 54 * 2, height: UIScreen.main.bounds.height - 64 - 32))
        barBackgroundView.tableView.delegate = self as? UITableViewDelegate;
        barBackgroundView.tableView.dataSource = self as? UITableViewDataSource;
        barBackgroundView.tableView.separatorStyle = .none;
        barBackgroundView.tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: Constants.kDDCContractDetailCellIdentifier)
        return barBackgroundView;
    }()
    
    init(detailsID: String) {
        super.init(nibName: nil, bundle: nil)
        self.detailsID = detailsID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: "#F8F8F8")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_back"), style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "#F8F8F8")

        self.view.addSubview(self.barBackgroundView)
        self.setupViewConstraints()
        self.title = "合同详情"
        
    }
    
    // MARK: Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: private
    func setupViewConstraints() {
        self.barBackgroundView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(32 + 64);
            make.left.equalTo(self.view).offset(54);
            make.right.equalTo(self.view).offset(-54);
            make.bottom.equalTo(self.view);
        })
    }
    
  
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCContractDetailsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.barBackgroundView.tableView.dequeueReusableCell(withIdentifier: Constants.kDDCContractDetailCellIdentifier, for: indexPath)) as! DDCContractDetailsCell;
        
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
