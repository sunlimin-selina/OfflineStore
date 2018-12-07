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
        let url:String = DDC_Current_Url.appendingFormat("/customer/channel/list.do")
        
        DDCHttpSessionsRequest.callGetRequest(url: url, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let channelsArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let channels:[DDCChannelModel] = Mapper<DDCChannelModel>().mapArray(JSONArray: channelsArray)
                successHandler(channels)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func uploadUserInfo(model: DDCContractModel, successHandler: @escaping (_ result: DDCContractModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/customer/register.do")
        let params: Dictionary<String,Any> = ["mobile": model.customer!.mobile ?? "",
                                                 "name": model.customer!.name ?? "",
                                                 "sex": model.customer!.sex?.rawValue as Any,
            "birthday": "\(model.customer!.birthday!)",
            "career": model.customer!.career != nil ? model.customer!.career!.rawValue : 7,
            "email": model.customer!.email ?? "",
            "channelCode": model.customer!.channelCode ?? "",
            "channelDesc": model.customer!.channelDesc ?? "",
            "isIntroduce": model.customer!.isReferral ? 1 : 0,
            "introduceMobile": (model.customer!.introduceMobile != nil) ? model.customer!.introduceMobile! : "",
            "introduceName": (model.customer!.introduceName != nil) ? model.customer!.introduceName! : "",
            "dutyUserId": (model.customer!.dutyUserId != nil && model.customer!.dutyUserId != 0) ? model.customer!.dutyUserId as Any : DDCStore.sharedStore().user?.id as Any]
        print(params)
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                DDCEditClientInfoAPIManager.getUserContractInfo(model: model, dictionary: data, successHandler: { (contractModel) in
                    successHandler(contractModel)
                }, failHandler: { (error) in
                    successHandler(nil)
                })
            }
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getUserContractInfo(model: DDCContractModel, dictionary: Dictionary<String, Any>, successHandler: @escaping (_ result: DDCContractModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/customer/contract_course_info.do")
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
                model.contractUseCount = contract.contractUseCount
                model.contractAllCount = contract.contractAllCount
                model.reservationCount = contract.reservationCount
                model.lastCourseName = contract.lastCourseName
                model.customer?.userId = customer.userId
                model.customer?.name = customer.name
                model.customer?.mobile = customer.mobile
                successHandler(model)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)

        }
    }
}
