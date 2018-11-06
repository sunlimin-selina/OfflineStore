//
//  DDCCreateContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCreateContractViewController: UIViewController{
    
    enum DDCContractProgress : UInt {
        case addPhoneNumber//添加手机号
        case editClientInformation//客户信息
        case addContractInformation//创建新合同
        case finishContract//创建成功
    }
    
    var progress : DDCContractProgress {
        get {
            return .addPhoneNumber
        }
        set {
            let interval: UInt = newValue.rawValue - DDCContractProgress.addPhoneNumber.rawValue
            
            for index in 0...(self.categorys.count - 1) {
                let model: DDCContractStateInfoViewModel = self.categorys[index]
                
                if index < interval {
                    model.state = DDCContractState.done
                }else if index == interval {
                    model.state = DDCContractState.doing
                }else{
                    model.state = DDCContractState.todo
                }
            }
            
            self.progressViewController.stages = self.categorys
        }
    }
    var model : DDCContractModel?
    
    var subviewControllers : Array<DDCChildContractViewController>? = Array()
    
    private lazy var bottomBar : DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .highlighted, handler: {
            self.nextPage(model: NSObject.init())
        }))
        return _bottomBar
    }()
    
    lazy var categorys : Array<DDCContractStateInfoViewModel> = {
        var titles : Array = ["客户信息", "门店及类型", "订单信息", "创建成功"]
        
        var _categorys = Array<Any>()
        var interval : UInt = self.progress.rawValue - DDCContractProgress.addPhoneNumber.rawValue
        
        for index in 0...(titles.count - 1){
            var model : DDCContractStateInfoViewModel = DDCContractStateInfoViewModel()
            model.title = titles[index]
            
            if index < interval {
                model.state = DDCContractState.done
            } else if index == interval {
                model.state = DDCContractState.doing
            } else {
                model.state = DDCContractState.todo
            }
            
            _categorys.append(model)
        }
        return _categorys as! [DDCContractStateInfoViewModel]
    }()
    
    lazy var progressViewController : DDCProgressViewController = {
        var _progressViewController = DDCProgressViewController.init(stages: self.categorys)
        return _progressViewController
    }()
    
    lazy var pageViewController : UIPageViewController = {
        var _pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        _pageViewController.delegate = self as UIPageViewControllerDelegate
        _pageViewController.dataSource = self as UIPageViewControllerDataSource
        _pageViewController.view.backgroundColor = UIColor.white
        var views : Array<Any> = _pageViewController.view.subviews
        
        for view in views {
            if view is UIScrollView {
                (view as! UIScrollView).isPagingEnabled = true
                (view as! UIScrollView).isScrollEnabled = false
                break
            }
        }
        return _pageViewController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_back"), style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraint()
        self.title = "创建新合同"
    }

    init(progress: DDCContractProgress, model: DDCContractModel?) {
        super.init(nibName: nil, bundle: nil)
        self.progress = progress
        self.model = model
        self.createChildViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension DDCCreateContractViewController : DDCChildContractViewControllerDelegate{
    func nextPage(model: NSObject) {
        if self.progress.rawValue >= self.subviewControllers!.count {return}
        var selectedIndex : Int = Int(self.progress.rawValue)
        selectedIndex += 1
        self.progress = DDCCreateContractViewController.DDCContractProgress(rawValue: UInt(selectedIndex))!
        
        let viewController : DDCChildContractViewController = self.subviewControllers![selectedIndex]
//        viewController.model = (model as! DDCContractModel)
        self.pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func previousPage(model: NSObject) {
        if self.progress.rawValue == 0 {return}
        var selectedIndex : Int = Int(self.progress.rawValue)
        selectedIndex -= 1
        self.progress = DDCCreateContractViewController.DDCContractProgress(rawValue: UInt(selectedIndex))!

        let viewController : DDCChildContractViewController = self.subviewControllers![selectedIndex]
        viewController.model = (model as! DDCContractModel)
        self.pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func createChildViewControllers() {
        let customerViewController: DDCEditClientInfoViewController  = DDCEditClientInfoViewController()
        customerViewController.index = 0
        customerViewController.delegate = self
        self.subviewControllers?.append(customerViewController)
        
        let storeViewController : DDCSelectStoreViewController = DDCSelectStoreViewController()
        storeViewController.index = 1
        storeViewController.delegate = self
        self.subviewControllers?.append(storeViewController)
        
        let contractViewController : DDCAddContractInfoViewController = DDCAddContractInfoViewController()
        contractViewController.index = 2
        contractViewController.delegate = self
        self.subviewControllers?.append(contractViewController)
        
        let paymentViewController : DDCPaymentViewController = DDCPaymentViewController()
        paymentViewController.index = 3
        paymentViewController.delegate = self
        self.subviewControllers?.append(paymentViewController)
        
        if self.model != nil {
            let viewController : DDCChildContractViewController = self.subviewControllers![Int(self.progress.rawValue)]
            viewController.model = self.model
        }
    }
    
    func setupViewConstraint() {
        self.view.backgroundColor = UIColor.white
        
        self.progressViewController.willMove(toParent: self)
        self.addChild(self.progressViewController)
        self.view.addSubview(self.progressViewController.view)
        
        self.progressViewController.view.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(0.05*screen.height + screen.statusBarHeight + screen.navigationBarHeight)
            make.width.equalTo(screen.width - 74)
            make.centerX.equalTo(self.view)
            make.height.equalTo(60.0)
        })
        
        self.progressViewController.didMove(toParent: self)
        
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressViewController.view.snp_bottomMargin).offset(0.05*screen.height)
            make.left.right.bottom.equalTo(self.view)
        }
        self.addChild(self.pageViewController)
        
        self.pageViewController.setViewControllers([self.subviewControllers![Int(self.progress.rawValue)]], direction: .forward, animated: true, completion: nil)
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })
        
        self.view.bringSubviewToFront(self.bottomBar)
    }
    
    @objc func goBack() {
        if self.model != nil {
            let alertController : UIAlertController = UIAlertController.init(title: "您确定要退出当前创建的新合同吗？", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "退出", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            alertController.addAction(UIAlertAction.init(title: "否", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension DDCCreateContractViewController :UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index : Int = (viewController as! DDCChildContractViewController).index
        index -= 1
        if index < 0 { return nil }
        return self.subviewControllers![index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index : Int = (viewController as! DDCChildContractViewController).index
        index += 1
        if index >= (self.subviewControllers?.count)! { return nil }
        return self.subviewControllers![index]
    }

}
