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
        let specMoney = (model!.specs?.costPrice != nil ? (model!.specs?.costPrice!)! * 100 : 0)
        let money = (model!.contractPrice != nil) ? model!.contractPrice! * 100 : specMoney
        let params: Dictionary<String, Any>? = ["amount": money, "contractNo": model?.code as Any, "operateBizType":"COURSE", "operateUserId": model?.customer?.dutyUserId ?? DDCStore.sharedStore().user?.id as Any, "operateUserType": 2, "payChannel": payChannel, "payStyle": payStyle, "sourcePaltform": 1]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                case let _data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                let model: DDCOnlinePaymentOptionModel = DDCOnlinePaymentOptionModel(JSON: _data)!
                successHandler(model)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func updatePaymentState(contractNo: String, successHandler: @escaping(_ result: DDCPaymentStatus) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/status/check_tradestatus.do")
        let params: Dictionary<String, Any>? = ["contractNo": contractNo]
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))! {
                successHandler(DDCPaymentStatus(rawValue: tuple.data as! Int)!)
                return
            }
            successHandler(.cancel)
        }) { (error) in
            failHandler(error)
        }
    }
}
