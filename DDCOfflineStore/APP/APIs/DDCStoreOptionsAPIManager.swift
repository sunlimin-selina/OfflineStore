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
            if DDCTools.isBlankObject(object: tuple.data) ,
                case let storesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let stores:[DDCStoreModel] = Mapper<DDCStoreModel>().mapArray(JSONArray: storesArray)
                successHandler(stores)
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
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let storesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let stores:[DDCStoreModel] = Mapper<DDCStoreModel>().mapArray(JSONArray: storesArray)
                successHandler(stores)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
}
