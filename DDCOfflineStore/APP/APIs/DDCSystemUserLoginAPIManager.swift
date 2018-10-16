//
//  DDCSystemUserLoginAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire

class DDCSystemUserLoginAPIManager: NSObject {
    class func login(username : String,password:String ,successHandler: @escaping((_ user: DDCUserModel?) -> ()), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/loginByLine.do")
        let params : Dictionary<String, Any>? = ["username":username, "password":password]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseServerData(response: response)
            let data : Dictionary<String,Any> = tuple.data
            var user : DDCUserModel = DDCUserModel.init(dictionary: data)
            
            successHandler(user)
        }) { (code) in
            failHandler(code)
        }
    }
}
