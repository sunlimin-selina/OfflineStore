//
//  DDCConfirmOrderViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/12/17.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCConfirmOrderViewController: DDCChildContractViewController {
    struct constant{
        static let kMargin: CGFloat = 54.0
    }
    
    public var detailsID: String?
    var modelArray: [DDCContractDetailsViewModel]? = Array()
    var model: DDCContractModel? {
        get {
            return _model
        }
    }
    
    public lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.register(DDCContractDetailsCell.self, forCellReuseIdentifier: String(describing: DDCContractDetailsCell.self))
        return tableView
    }()
    
    lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: screen.width, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            self.delegate?.previousPage(model: self.model!)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "去付款", style: .forbidden, handler: {
//            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.tableView)
    }
    
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension DDCConfirmOrderViewController: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCContractDetailsCell.self), for: indexPath)) as! DDCContractDetailsCell
        cell.selectionStyle = .none
        let model: DDCContractDetailsViewModel = self.modelArray![indexPath.row]
        cell.titleLabel.text = model.title
        cell.subtitleLabel.text = model.describe
        cell.subtitleLabel.textColor = model.color
        return cell
    }
    
}
