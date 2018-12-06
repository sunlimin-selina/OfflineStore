//
//  DDCVersionCheckAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/12/6.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
class DDCVersionCheckAPIManager : NSObject {
    class func checkVersion(successHandler: @escaping (_ version: String?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/version/ios.do")
        
        DDCHttpSessionsRequest.callGetRequest(url: url, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }            
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                case let data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                successHandler((data["value"] as! String))
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
}
