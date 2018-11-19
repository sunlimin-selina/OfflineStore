//
//  DDCSystemUserLoginAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCSystemUserLoginAPIManager: NSObject {
    class func login(username: String,password:String ,successHandler: @escaping((_ user: DDCUserModel?) -> ()), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/loginByLine.do")
        let params: Dictionary<String, Any>? = ["username":username, "password":password]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if case let data as Dictionary<String, Any> = tuple.data {
                let user: DDCUserModel = DDCUserModel(JSON: data)!
                successHandler(user)
            }
        }) { (code) in
            failHandler(code)
        }
    }
    
    class func getUserInfo(phoneNumber: String, successHandler: @escaping((_ user: DDCCustomerModel?) -> ()), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/customer/mobile/get.do")
        let params: Dictionary<String, Any>? = ["mobile":phoneNumber]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return 
            }
            if case let data as Dictionary<String, Any> = tuple.data {
                let user: DDCCustomerModel = DDCCustomerModel(JSON: data)!
                successHandler(user)
            }
        }) { (code) in
            failHandler(code)

        } 
    }
}
