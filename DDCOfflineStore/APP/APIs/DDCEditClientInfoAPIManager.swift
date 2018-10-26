//
//  DDCEditClientInfoAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCEditClientInfoAPIManager: NSObject {
    class func availableChannels(successHandler: @escaping (_ result : [DDCChannelModel]?) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/userChannelList.do")
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: nil, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            var array: [DDCChannelModel] = Array()
            if case let channels as Array<Any> = tuple.data {
                for data in channels {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let channelModel : DDCChannelModel = DDCChannelModel(JSON: _data)!
                        array.append(channelModel)
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
