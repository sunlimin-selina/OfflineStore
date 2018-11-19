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
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/userChannelList.do")
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: nil, success: { (response) in
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
        let url:String = DDC_Current_Url.appendingFormat("/server/user/registerLineUser.do")
        var params: Dictionary<String,String> = ["userName": model.customer!.mobile!,
                                                 "lineUserName": model.customer!.name!,
                                                 "sex": "\(model.customer!.sex!.rawValue - 1)",
            "birthday": "\(model.customer!.birthday!)",
            "lineUserEmail": model.customer!.email!,
//            "lineUserCareer": model.customer!.career!.rawValue as String,
            "channel": model.customer!.channelCode!,
            "type": "3",
            "uid": "\(DDCStore.sharedStore().user!.id!)"]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if let data = tuple.data {
                if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                    let model: DDCContractModel = DDCContractModel(JSON: _data)!
                    successHandler(model)
                }
                successHandler(nil)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
}
