//
//  DDCStoreAndContractTypeAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/3.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCStoreAndContractTypeAPIManager: NSObject {
    class func getStoresAndContractTypes(successHandler: @escaping (_ result: [DDCStoreModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/offline/address/list.do")
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: nil, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            var array: Array<DDCStoreModel> = Array()
            
            if case let stores as Array<Any> = tuple.data {
                for data in stores {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let storeModel: DDCStoreModel = DDCStoreModel(JSON: _data)!
                        array.append(storeModel)
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
    
}
