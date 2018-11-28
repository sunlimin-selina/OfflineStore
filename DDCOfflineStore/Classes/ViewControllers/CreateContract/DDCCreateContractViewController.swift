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
    
    enum DDCContractProgress: UInt {
        case editClientInformation//客户信息
        case storeAndContractType//门店及类型
        case addContractInformation//订单信息
        case finishContract//创建成功
    }
    
    var onlyForPayment: Bool = false
    
    
    lazy var customerViewController: DDCEditClientInfoViewController = {
        let _customerViewController: DDCEditClientInfoViewController  = DDCEditClientInfoViewController()
        _customerViewController.index = 0
        _customerViewController.delegate = self
        return _customerViewController
    }()
    
    lazy var storeViewController: DDCSelectStoreViewController = {
        let _storeViewController: DDCSelectStoreViewController = DDCSelectStoreViewController()
        _storeViewController.index = 1
        _storeViewController.delegate = self
        return _storeViewController
    }()
    
    lazy var groupContractViewController: DDCGroupContractInfoViewController = {
        let _groupContractViewController: DDCGroupContractInfoViewController = DDCGroupContractInfoViewController()
        _groupContractViewController.index = 2
        _groupContractViewController.delegate = self
        return _groupContractViewController
    }()
    
    lazy var contractViewController: DDCAddContractInfoViewController = {
        let _contractViewController: DDCAddContractInfoViewController = DDCAddContractInfoViewController()
        _contractViewController.index = 2
        _contractViewController.delegate = self
        return _contractViewController
    }()
    
    lazy var paymentViewController: DDCPaymentViewController = {
        let _paymentViewController: DDCPaymentViewController = DDCPaymentViewController()
        _paymentViewController.index = 3
        _paymentViewController.delegate = self
        return _paymentViewController
    }()
    
    var progress: DDCContractProgress? {
        didSet {
            let interval: UInt = progress!.rawValue - DDCContractProgress.editClientInformation.rawValue
            
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
    var model: DDCContractModel?
    
    var subviewControllers: [DDCChildContractViewController] {
        get {
            return self.createChildViewControllers(type: .group)
        }
    }
    
    lazy var categorys: Array<DDCContractStateInfoViewModel> = {
        var titles: Array = ["客户信息", "门店及类型", "订单信息", "创建成功"]
        
        var _categorys = Array<Any>()
        var interval: UInt = self.progress!.rawValue - DDCContractProgress.editClientInformation.rawValue
        
        for index in 0...(titles.count - 1){
            var model: DDCContractStateInfoViewModel = DDCContractStateInfoViewModel()
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
    
    lazy var progressViewController: DDCProgressViewController = {
        var _progressViewController = DDCProgressViewController.init(stages: self.categorys)
        return _progressViewController
    }()
    
    lazy var pageViewController: UIPageViewController = {
        var _pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        _pageViewController.delegate = self as UIPageViewControllerDelegate
        _pageViewController.dataSource = self as UIPageViewControllerDataSource
        _pageViewController.view.backgroundColor = UIColor.white
        var views: Array<Any> = _pageViewController.view.subviews
        
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20.0, weight: .medium)]
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_back"), style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConstraint()
        self.title = "创建新订单"
        self.navigationController!.interactivePopGestureRecognizer?.delegate = self
    }
    
    init(progress: DDCContractProgress, model: DDCContractModel?) {
        super.init(nibName: nil, bundle: nil)
        self.progress = progress
        self.model = model
    }
    
    init(toPaymentView model: DDCContractModel?) {
        super.init(nibName: nil, bundle: nil)
        self.progress = .finishContract
        self.model = model
        self.onlyForPayment = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension DDCCreateContractViewController: DDCChildContractViewControllerDelegate{
    override func navigationShouldPopMethod(){
        self.goBack()
    }
    
    func nextPage(model: DDCContractModel) {
        if self.progress!.rawValue >= self.subviewControllers.count {return}
        var selectedIndex: Int = Int(self.progress!.rawValue)
        selectedIndex += 1
        self.progress = DDCCreateContractViewController.DDCContractProgress(rawValue: UInt(selectedIndex))!
        
        if selectedIndex == 2 && model.courseType == DDCCourseType.group {
            selectedIndex = 4
        }
        let viewController: DDCChildContractViewController = self.subviewControllers[selectedIndex]
        viewController.model = model
        self.pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func previousPage(model: DDCContractModel) {
        if self.progress!.rawValue == 0 {return}
        var selectedIndex: Int = Int(self.progress!.rawValue)
        selectedIndex -= 1
        self.progress = DDCCreateContractViewController.DDCContractProgress(rawValue: UInt(selectedIndex))!
        
        if selectedIndex == 3 && model.courseType == DDCCourseType.group {
            selectedIndex = 4
        }
        let viewController: DDCChildContractViewController = self.subviewControllers[selectedIndex]
        viewController.model = model
        self.pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func createChildViewControllers(type: DDCCourseType) -> [DDCChildContractViewController] {
        var subviewControllers: [DDCChildContractViewController] = Array()
        
        if self.onlyForPayment {
            self.paymentViewController.model = self.model
            subviewControllers.append(self.paymentViewController)
        } else {
            
            subviewControllers.append(self.customerViewController)
            subviewControllers.append(self.storeViewController)
            subviewControllers.append(self.contractViewController)
            subviewControllers.append(self.paymentViewController)
            subviewControllers.append(self.groupContractViewController)
            
            if self.model != nil {
                let viewController: DDCChildContractViewController = self.subviewControllers[Int(self.progress!.rawValue)]
                viewController.model = self.model
            }
        }
        return subviewControllers
    }
    
    func setupViewConstraint() {
        self.view.backgroundColor = UIColor.white
        
        self.progressViewController.willMove(toParent: self)
        self.addChild(self.progressViewController)
        self.view.addSubview(self.progressViewController.view)
        
        self.progressViewController.view.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(screen.statusBarHeight + screen.navigationBarHeight)
            make.width.equalTo(screen.width - 74)
            make.centerX.equalTo(self.view)
            make.height.equalTo(DDCProgressViewController.height)
        })
        
        self.progressViewController.didMove(toParent: self)
        
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressViewController.view.snp_bottomMargin)
            make.left.right.bottom.equalTo(self.view)
        }
        self.addChild(self.pageViewController)
        
        if self.onlyForPayment {
            self.pageViewController.setViewControllers([self.subviewControllers[0]], direction: .forward, animated: true, completion: nil)
            
        } else {
            self.pageViewController.setViewControllers([self.subviewControllers[Int(self.progress!.rawValue)]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc func goBack() {
        if self.model != nil {
            let alertController: UIAlertController = UIAlertController.init(title: "您确定要退出当前创建的新合同吗？", message: nil, preferredStyle: .alert)
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
        var index: Int = (viewController as! DDCChildContractViewController).index
        index -= 1
        if index < 0 { return nil }
        return self.subviewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! DDCChildContractViewController).index
        index += 1
        if index >= (self.subviewControllers.count) { return nil }
        return self.subviewControllers[index]
    }
    
}

extension DDCCreateContractViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        }else{
            return true
        }
    }
}
