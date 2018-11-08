//
//  DDCBasicViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCBasicViewController: UIViewController {
    static let kDefaultView: String = "kDefault"

    override func viewDidLoad() {
        super.viewDidLoad()
        //KVO
        self.addObserver(self, forKeyPath: DDCBasicViewController.kDefaultView, options: .new, context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: DDCBasicViewController.kDefaultView)
    }
}
