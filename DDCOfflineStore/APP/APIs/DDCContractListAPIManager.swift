//
//  DDCContractListAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCContractListAPIManager: NSObject {
    class func getContractList(page: UInt,status:Int, type:Int ,successHandler: @escaping (_ result: [DDCContractListModel]) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/list.do")
        let uid:String = String(format:"%d",(DDCStore.sharedStore().user?.id)!)

        let params: Dictionary<String, Any> = ["createUserId":uid , "currentPage":page ,"status":status , "type": type,  "pageSize": 10]
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data),
                case let packagesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let packages:[DDCContractListModel] = Mapper<DDCContractListModel>().mapArray(JSONArray: packagesArray)
                successHandler(packages)
                return
            }
            successHandler([])
        }) { (error) in
            failHandler(error)
        }
    }
    
}

