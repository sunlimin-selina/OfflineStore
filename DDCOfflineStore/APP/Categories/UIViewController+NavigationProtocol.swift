//
//  UIViewController+NavigationProtocol.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/24.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

/// 导航返回协议
@objc protocol DDCNavigationProtocol {
    @objc optional func navigationShouldPopMethod()
}

extension UIViewController: DDCNavigationProtocol {
    
    func navigationShouldPopMethod() {
        self.navigationController?.popViewController(animated: true)
    }
}

//extension UINavigationController {
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        // 强制开启侧滑返回操作
//        interactivePopGestureRecognizer?.delegate = self
//    }
//}

extension UINavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        } else {
            if topViewController?.responds(to: #selector(navigationShouldPopMethod)) != nil {
                topViewController!.navigationShouldPopMethod()
                return true
            }
            return true
        }
    }

    
}
