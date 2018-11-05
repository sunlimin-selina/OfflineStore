//
//  DDCChildContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCChildContractViewController: UIViewController {
    var delegate : DDCChildContractViewControllerDelegate?
    var model : DDCContractModel?
    var index : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

protocol DDCChildContractViewControllerDelegate {
    func nextPage(model: NSObject)
    func previousPage(model: NSObject)
    
    
}
