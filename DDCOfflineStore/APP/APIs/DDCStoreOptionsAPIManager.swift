//
//  DDCStoreOptionsAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCStoreOptionsAPIManager: NSObject {
    class func getStoreOptions(currentStoreId: Int, successHandler: @escaping (_ result: [DDCStoreModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/offline/address/newListById.do")
        let params: Dictionary<String , Any> = ["id":currentStoreId]

        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
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
    
    class func getRelationShopOptions(currentStoreId: Int, successHandler: @escaping (_ result: [DDCStoreModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/shop/relation-shop-list.do")
        let params: Dictionary<String , Any> = ["id":currentStoreId]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
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
}
