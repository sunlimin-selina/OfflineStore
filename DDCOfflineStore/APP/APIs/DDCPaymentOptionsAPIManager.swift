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
    
    class func paymentOption(phone: String, successHandler: @escaping(_ result: (online: DDCPaymentOptionModel?, offline: DDCPaymentOptionModel?)?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/pay/style/list.do")
        let params: Dictionary<String, Any>? = ["platform": phone, "appType": ""]
        var result: (online: DDCPaymentOptionModel?, offline: DDCPaymentOptionModel?)
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if case let payments as Array<Any> = tuple.data {
                for data in payments {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCPaymentOptionModel = DDCPaymentOptionModel(JSON: _data)!
                        if model.code == "2" {
                            result.offline = model
                        } else {
                            result.online = model
                        }
                    }
                }
                successHandler(result)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func createPaymentOption(model: DDCContractModel?, payChannel: String, payStyle: Int, successHandler: @escaping(_ result: DDCOnlinePaymentOptionModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/pay/order/create_pay.do")
        let params: Dictionary<String, Any>? = ["amount": 10000, "contractNo": "www-ddc-000", "operateBizType":"COURSE", "operateUserId": 1, "operateUserType": 2, "payChannel": payChannel, "payStyle": payStyle, "sourcePaltform": 1]//model.contractPrice as Any
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if case let payments as Array<Any> = tuple.data {
                for data in payments {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCOnlinePaymentOptionModel = DDCOnlinePaymentOptionModel(JSON: _data)!
                        successHandler(model)
                        return
                    }
                }
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
}
