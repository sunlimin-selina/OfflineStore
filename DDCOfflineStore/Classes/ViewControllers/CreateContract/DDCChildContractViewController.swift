//
//  DDCChildContractViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCChildContractViewController: UIViewController {
    var delegate: DDCChildContractViewControllerDelegate?
    var index: Int = 0
    var _model: DDCContractModel?
}

protocol DDCChildContractViewControllerDelegate {
    func nextPage(model: DDCContractModel)
    func previousPage(model: DDCContractModel)
}
