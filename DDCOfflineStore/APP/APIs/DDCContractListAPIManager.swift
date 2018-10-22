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
    class func getContractList(page : UInt,status:UInt ,successHandler: @escaping (_ result : [DDCContractDetailsModel]) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/list.do")
        let uid:String = String(format:"%d",(DDCStore.sharedStore().user?.id)!)

        let params : Dictionary<String, Any> = ["uid":uid , "currentPage":page ,"status":status , "pageSize" : 10]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            if let res = response {
                let modelArray: [DDCContractDetailsModel] = DDCContractListAPIManager.parseDictionary((res["data"] as! [Dictionary<String, Any>]))!
                successHandler(modelArray)
            }
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func parseDictionary(_ dataArray : [Dictionary<String, Any>]?) -> [DDCContractDetailsModel]? {
        if let array = dataArray {
            var modelArray : Array<DDCContractDetailsModel> = Array()
            for dictionary in array {
                let user : DDCCustomerModel = DDCCustomerModel(JSON: dictionary)!
                let info : DDCContractInfoModel = DDCContractInfoModel(JSON: dictionary)!
                let detailModel : DDCContractDetailsModel = DDCContractDetailsModel(JSON: dictionary)!
                detailModel.user = user
                detailModel.info = info
                modelArray.append(detailModel)
            }
            return modelArray
        }
        return nil
    }
}

