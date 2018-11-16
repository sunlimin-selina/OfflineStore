//
//  DDCPaymentOptionsAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCPaymentOptionsAPIManager: NSObject {
    class func paymentOptions(contractId: String, price: String, successHandler: @escaping (_ result: (wechat: DDCOnlinePaymentOptionModel?, alipay: DDCOnlinePaymentOptionModel?, offline: [DDCPaymentOptionModel]?)?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        var result: (wechat: DDCOnlinePaymentOptionModel?, alipay: DDCOnlinePaymentOptionModel?, offline: [DDCPaymentOptionModel]?)
        var wechat: DDCOnlinePaymentOptionModel?
        var alipay: DDCOnlinePaymentOptionModel?
        var offline: [DDCPaymentOptionModel]? = Array()
        var errorMessage: String?

        workingGroup.enter()
        workingQueue.async {
            DDCPaymentOptionsAPIManager.wechatPayment(contractId: contractId, price: price, successHandler: { (wechatModel) in
                wechat = wechatModel
                workingGroup.leave()
            }, failHandler: { (error) in
                errorMessage = error
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCPaymentOptionsAPIManager.alipayPayment(contractId: contractId, price: price, successHandler: { (alipayModel) in
                alipay = alipayModel
                workingGroup.leave()
            }, failHandler: { (error) in
                errorMessage = error
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCPaymentOptionsAPIManager.offlinePayment(successHandler: { (models) in
                offline = models
                workingGroup.leave()
            }, failHandler: { (error) in
                errorMessage = error
                workingGroup.leave()
            })
        }
        
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                // 主线程中
                if let _wechat = wechat,
                    let _alipay = alipay,
                    (offline?.count)! > 0 {
                    result = (_wechat, _alipay, offline)
                    successHandler(result)
                } else {
                    failHandler(errorMessage ?? "")
                }
            }
        }
    }
    
    class func wechatPayment(contractId: String, price: String, successHandler: @escaping (_ result: DDCOnlinePaymentOptionModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/payment/wxPaySign.do")
        let params: Dictionary<String, Any>? = ["payMethodId": DDCAppConfig.payment.kWechatPaymentID, "productId": contractId, "totalAmount": price]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if let data = tuple.data {
                if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                    let model: DDCOnlinePaymentOptionModel = DDCOnlinePaymentOptionModel(JSON: _data)!
                    successHandler(model)
                    return
                }
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func alipayPayment(contractId: String, price: String, successHandler: @escaping (_ result: DDCOnlinePaymentOptionModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/payment/alipaySign.do")
        let params: Dictionary<String, Any>? = ["payMethodId": DDCAppConfig.payment.kAlipayPaymentID, "productId": contractId, "totalAmount": price]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if let data = tuple.data {
                if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                    let model: DDCOnlinePaymentOptionModel = DDCOnlinePaymentOptionModel(JSON: _data["alipay_trade_precreate_response"] as! Dictionary<String, Any>)!
                    successHandler(model)
                    return
                }
                successHandler(nil)
            }
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func offlinePayment(successHandler: @escaping (_ result: [DDCPaymentOptionModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/offline/option/list.do")
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: nil, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            var array: [DDCPaymentOptionModel] = Array()
            if case let payments as Array<Any> = tuple.data {
                for data in payments {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCPaymentOptionModel = DDCPaymentOptionModel(JSON: _data)!
                        array.append(model)
                    }
                }
                successHandler(array)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
}
