//
//  DDCContractDetailsAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias Package = (packageName: String, packageCategoryName: String, singleStore: Bool)?

class DDCContractDetailsAPIManager: NSObject {
    
    class func getContractDetails(detailId: String ,successHandler: @escaping (_ result: DDCContractDetailModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/detail.do")
        let param: Dictionary = ["contractNo": detailId]
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            print(tuple.data)
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                case let data: Dictionary<String, Any> = tuple.data as! Dictionary<String, Any>{
                let contractDetail: DDCContractDetailModel = DDCContractDetailModel(JSON: data)!
                successHandler(contractDetail)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
   
    class func cancelContract(model: DDCContractDetailModel ,successHandler: @escaping (_ result: Bool) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/cancel.do")
        let param: Dictionary<String, Any> = ["contractNo": model.code as Any, "operateBizType":"COURSE", "operateUserId":DDCStore.sharedStore().user?.id as Any, "operateUserType":2, "sourcePaltform":1]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            successHandler(true)
        }) { (error) in
            failHandler(error)
        }
    }
}
