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
    class func getContractList(page: UInt,status:UInt, type:UInt ,successHandler: @escaping (_ result: [DDCContractListModel]) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/contract/list.do")
        let uid:String = String(format:"%d",(DDCStore.sharedStore().user?.id)!)

        let params: Dictionary<String, Any> = ["createUserId":uid , "currentPage":page ,"status":status , "type": type,  "pageSize": 10]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            var array: Array<DDCContractListModel> = Array()
            if case let packages as Array<Any> = tuple.data {
                for data in packages {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCContractListModel = DDCContractListModel(JSON: _data)!
                        array.append(model)
                    }
                }
                successHandler(array)
                return
            }
            successHandler([])
        }) { (error) in
            failHandler(error)
        }
    }
    
//    class func parseDictionary(_ dataArray: [Dictionary<String, Any>]?) -> [DDCContractListModel]? {
//        if let array = dataArray {
//            var modelArray: Array<DDCContractListModel> = Array()
//            for dictionary in array {
//                let user: DDCCustomerModel = DDCCustomerModel(JSON: dictionary)!
//                let info: DDCContractInfoModel = DDCContractInfoModel(JSON: dictionary)!
//                let detailModel: DDCContractListModel = DDCContractListModel(JSON: dictionary)!
//                detailModel.user = user
//                detailModel.info = info
//                modelArray.append(detailModel)
//            }
//            return modelArray
//        }
//        return nil
//    }
}

