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
        let url:String = DDC_Current_Url.appendingFormat("/shop/list.do")
        
        DDCHttpSessionsRequest.callGetRequest(url: url, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            var array: Array<DDCStoreModel> = Array()
            
            if tuple.data != nil ,
                case let stores as Array<Any> = tuple.data {
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
    
    class func getLastStore(successHandler: @escaping (_ storeId: CLong?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/shop/relation-shop-id.do")
        let param: Dictionary<String, Any> = ["dealUserId": DDCStore.sharedStore().user?.id as Any]

        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if tuple.data != nil, !(tuple.data?.isKind(of: NSNull.self))!,
                let data = tuple.data {
                successHandler((data as! Int))
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
}
