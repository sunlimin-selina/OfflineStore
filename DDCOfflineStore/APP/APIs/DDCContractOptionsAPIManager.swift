//
//  DDCContractOptionsAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCContractOptionsAPIManager: NSObject {
    class func packagesForContract(storeId: Int, successHandler: @escaping (_ result: [DDCContractPackageModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/contractPackageSku.do")
        let params = ["addressId": storeId]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            var array: Array<DDCContractPackageModel> = Array()
            
            if case let packages as Array<Any> = tuple.data {
                for data in packages {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCContractPackageModel = DDCContractPackageModel(JSON: _data)!
                        array.append(model)
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
    
    class func getCustomCourse(storeId: Int, successHandler: @escaping (_ result: [DDCCourseModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/categorylist.do")
        let params = ["addressId": storeId]
        
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            var array: Array<DDCCourseModel> = Array()
            if case let courses as Array<Any> = tuple.data {
                for data in courses {
                    if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                        let model: DDCCourseModel = DDCCourseModel(JSON: _data)!
                        array.append(model)
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
