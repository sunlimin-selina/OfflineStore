//
//  DDCFinishedContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/28.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCFinishedContractViewController: UIViewController {
    var model: DDCContractModel?
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: screen.width, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "查看合同", style: .normal, handler: {
            [unowned self] in
            self.gotoContractDetail()
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "完成", style: .highlighted, handler: {
            [unowned self] in
            DDCOrderingTableViewController.courseType = nil
            DDCOrderingTableViewController.courseStatus = nil
            for viewController in (self.navigationController?.children)! {
                if viewController == self.navigationController?.children[0] {
                    self.navigationController?.popToViewController(viewController, animated: true)
                }
            }
        }))
        return _bottomBar
    }()
    
    init(model: DDCContractModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
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
        self.title = "支付结果"
        self.view.backgroundColor = UIColor.white

        DDCDefaultView.sharedView().showPromptView(view: self.view, title: "合同创建成功", image: UIImage.init(named: "zhifuchenggong_queshengtu")!, topPadding: 350)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
    }
    
    // MARK: Action
    @objc func goBack() {
        for viewController in (self.navigationController?.children)! {
            if viewController == self.navigationController?.children[0] {
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    func gotoContractDetail() {
        let viewController: DDCContractDetailsViewController = DDCContractDetailsViewController.init(detailsID: self.model!.code!)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupViewConstraints() {
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })
    }
}


