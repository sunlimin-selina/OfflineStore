//
//  DDCContractDetailsAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DDCContractDetailsAPIManager: NSObject {
    class func fetchContractDetails(detailId : Int ,successHandler: @escaping (_ result : Dictionary<String, Any>?) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        var data : Dictionary<String , Any> = Dictionary()
        
        workingGroup.enter()
        workingQueue.async {
            DDCContractDetailsAPIManager.getContractDetails(detailId: detailId, successHandler: { (model) in
                data["contractModel"] = model
                workingGroup.leave()
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCContractDetailsAPIManager.getContractPackageInfo(detailId: detailId, successHandler: { (packageName, packageCategoryName, singleStore) in
                data["packageName"] = packageName
                data["packageCategoryName"] = packageCategoryName
                data["singleStore"] = singleStore

                workingGroup.leave()
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCEditClientInfoAPIManager.availableChannels(successHandler: { (model) in
                data["availableChannels"] = model
                workingGroup.leave()
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.notify(queue: workingQueue) {
            let model : DDCContractModel = data["contractModel"] as! DDCContractModel
            DDCTools.hideHUD()

            if let modelId = model.currentStore?.id {
                DDCStoreOptionsAPIManager.getStoreOptions(currentStoreId: modelId, successHandler: { (array) in
                    data["storeOptions"] = array
                    successHandler(data)
                }, failHandler: { (error) in
                    successHandler(nil)
                })
            }
        }
    }
    
    class func getContractDetails(detailId : Int ,successHandler: @escaping (_ result : DDCContractModel) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/detail.do")
        let param : Dictionary = ["id":detailId]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            if case let data as Dictionary<String, Any> = tuple.data!["userContract"] {
                let contractDetail : DDCContractModel = DDCContractModel(JSON: data)!
                let user: Dictionary<String, Any> = (data["user"] as? Dictionary<String, Any>)!
                let store: Dictionary<String, Any> = (data["currentCourseAddress"] as? Dictionary<String, Any>)!

                contractDetail.customer = DDCCustomerModel(JSON: user)
                contractDetail.currentStore = DDCStoreModel(JSON: store)
                successHandler(contractDetail)
            }
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getContractPackageInfo(detailId : Int ,successHandler: @escaping (_ packageName: String, _ packageCategoryName: String,_ singleStore: Bool) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/packageskuincontractdetial.do")
        let param : Dictionary = ["id":detailId]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            if case let data as Dictionary<String, Any> = tuple.data {
                let packageName : String = data["packageName"] as! String
                let packageCategoryName : String = data["skuName"] as! String
                let singleStore : Bool = data["addressUseType"] as! Int == 1 ? true : false
                successHandler(packageName, packageCategoryName, singleStore);
            }
        }) { (error) in
            failHandler(error)
        }
    }
   
}
