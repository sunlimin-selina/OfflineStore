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
    
    @objc func checkUpdates(paymentModel: DDCOnlinePaymentOptionModel) {
        weak var weakSelf = self
        if let contractNo = paymentModel.contractNo {
            DDCPaymentOptionsAPIManager.updatePaymentState(contractNo: contractNo, successHandler: { (status) in
                switch (status){
                case .unpaid:
                    weakSelf?.perform(#selector(self.checkUpdates(paymentModel:)), with: paymentModel, afterDelay: 5)
                    break
                case .paid, .effective, .overdue:
                    NSObject.cancelPreviousPerformRequests(withTarget: weakSelf as Any)
                    weakSelf?.delegate?.payment(updateChecker: weakSelf!, paymentOption: paymentModel, status: status)
                    weakSelf?.currentlyCheckingArray.remove(paymentModel)
                    break
                default:
                    NSObject.cancelPreviousPerformRequests(withTarget: weakSelf as Any, selector: #selector(self.checkUpdates(paymentModel:)), object: paymentModel)
                    break
                }
            }) { (error) in
                weakSelf?.delegate?.payment(updateChecker: weakSelf!, paymentOption: paymentModel, status: .cancel)
                weakSelf?.currentlyCheckingArray.remove(paymentModel)
            }
        }
       
    }
    
    func cancel() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}
