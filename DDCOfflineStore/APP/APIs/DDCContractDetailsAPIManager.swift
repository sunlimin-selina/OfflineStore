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
    
    class func getContractDetails(detailId: Int ,successHandler: @escaping (_ result: DDCContractDetailModel?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/detail.do")
        let param: Dictionary = ["contractId": CLong(detailId)]
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
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
   
}
