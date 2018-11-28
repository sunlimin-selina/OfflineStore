//
//  DDCEditClientInfoAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCEditClientInfoAPIManager: NSObject {
    class func availableChannels(successHandler: @escaping (_ result: [DDCChannelModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/user/channel/list.do")
        
        DDCHttpSessionsRequest.callGetRequest(url: url, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            var array: [DDCChannelModel] = Array()
            if case let channels as Array<Any> = tuple.data {
                for data in channels {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let channelModel: DDCChannelModel = DDCChannelModel(JSON: _data)!
                        array.append(channelModel)
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
    
    class func uploadUserInfo(model: DDCContractModel, successHandler: @escaping (_ result: DDCContractModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/user/register.do")
        let params: Dictionary<String,Any> = ["mobile": model.customer!.mobile!,
                                                 "name": model.customer!.name!,
                                                 "sex": 1,
            "birthday": "\(model.customer!.birthday!)",
            "career": model.customer!.career != nil ? model.customer!.career!.rawValue + 1 : 7,
            "email": model.customer!.email!,
            "channelCode": model.customer!.channelCode ?? "",
            "channelDesc": model.customer!.channelDesc!,
            "isIntroduce": model.customer!.isReferral ? 1 : 0,
            "introduceMobile": (model.customer!.introduceMobile != nil) ? model.customer!.introduceMobile as Any : "",
            "introduceName": (model.customer!.introduceName != nil) ? model.customer!.introduceName as Any : "",
            "dutyUserId": (model.customer!.dutyUserId != nil) ? model.customer!.dutyUserId as Any : DDCStore.sharedStore().user?.id as Any]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                case let data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                DDCEditClientInfoAPIManager.getUserContractInfo(dictionary: data, successHandler: { (model) in
                    successHandler(model)
                    return
                }, failHandler: { (error) in
                    successHandler(nil)
                    return
                })
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getUserContractInfo(dictionary: Dictionary<String, Any>, successHandler: @escaping (_ result: DDCContractModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/user/contract_course_info.do")
        let params: Dictionary<String,Any> = ["userId": dictionary["userId"] as Any,
                                              "name": dictionary["name"] as Any,
                                              "mobile": dictionary["mobile"] as Any]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                case let _data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                let customer: DDCCustomerModel = DDCCustomerModel(JSON: _data)!
                let contract: DDCContractModel = DDCContractModel(JSON: _data)!
                contract.customer = customer
                successHandler(contract)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)

        }
    }
}
