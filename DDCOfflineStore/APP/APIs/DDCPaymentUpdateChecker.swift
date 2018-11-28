//
//  DDCPaymentUpdateChecker.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/28.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

protocol DDCPaymentUpdateCheckerDelegate {
    func payment(updateChecker: DDCPaymentUpdateChecker, paymentOption: DDCOnlinePaymentOptionModel, status: DDCPaymentStatus)
}

class DDCPaymentUpdateChecker: NSObject {
    var currentlyCheckingArray: NSMutableArray = NSMutableArray()
    var delegate: DDCPaymentUpdateCheckerDelegate?
    
    func startChecking(paymentModel: DDCOnlinePaymentOptionModel) {
        if !(self.currentlyCheckingArray.contains(paymentModel)) {
            self.currentlyCheckingArray.add(paymentModel)
            self.checkUpdates(paymentModel: paymentModel)
        }
    }
    
    func checkUpdates(paymentModel: DDCOnlinePaymentOptionModel) {
        weak var weakSelf = self
        DDCPaymentOptionsAPIManager.updatePaymentState(model: paymentModel, successHandler: { (status) in
            switch (status){
            case .failed:
                NSObject.cancelPreviousPerformRequests(withTarget: weakSelf as Any, selector: Selector(("checkUpdates:")), object: paymentModel)
                break
            case .success:
                NSObject.cancelPreviousPerformRequests(withTarget: weakSelf as Any)
                weakSelf?.delegate?.payment(updateChecker: weakSelf!, paymentOption: paymentModel, status: status)
                weakSelf?.currentlyCheckingArray.remove(paymentModel)
                break
            default:
                weakSelf?.perform(Selector(("checkUpdates:")), with: paymentModel, afterDelay: 5)
                break
            }
        }) { (error) in
            weakSelf?.delegate?.payment(updateChecker: weakSelf!, paymentOption: paymentModel, status: .failed)
            weakSelf?.currentlyCheckingArray.remove(paymentModel)
        }
    }
    
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}
