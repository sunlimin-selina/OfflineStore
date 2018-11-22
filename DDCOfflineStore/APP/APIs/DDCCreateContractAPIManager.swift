//
//  DDCCreateContractAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCCreateContractAPIManager: NSObject {
    class func saveContract(model:DDCContractModel, successHandler: @escaping (_ success: Bool?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/daydaycook/contract/save.do")
        let params: Dictionary<String, Any>? = DDCAddContractInfoModelFactory.packData(model: model)
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
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
