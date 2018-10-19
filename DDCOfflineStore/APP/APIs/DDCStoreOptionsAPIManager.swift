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
    class func getStoreOptions(currentStoreId: Int, successHandler: @escaping (_ result : [DDCStoreModel]?) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/offline/address/newListById.do")
        let params : Dictionary<String , Any> = ["id":currentStoreId]

        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            var array : Array<DDCStoreModel> = Array()
            
            if case let data as Dictionary<String, Any> = tuple.data {
                let channelModel : DDCStoreModel = DDCStoreModel(JSON: data)!
                array.append(channelModel)
                successHandler(array)
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
}
