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

typealias Package = (packageName: String, packageCategoryName: String, singleStore: Bool)?

class DDCContractDetailsAPIManager: NSObject {
    class func fetchContractDetails(detailId : Int ,successHandler: @escaping (_ result : (model: DDCContractModel?, channels: [DDCChannelModel]?, stores: [DDCStoreModel]?, package: Package)?) -> (), failHandler: @escaping (_ error : String) -> ()) {
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        var result:  (model: DDCContractModel?, channels: [DDCChannelModel]?, stores: [DDCStoreModel]?, package: Package)
        var model: DDCContractModel?
        var stores: [DDCStoreModel]?
        var package: Package
        var channels: [DDCChannelModel]?
        
        workingGroup.enter()
        workingQueue.async {
            DDCContractDetailsAPIManager.getContractDetails(detailId: detailId, successHandler: { (response)  in
                model = response
                if let modelId = response.currentStore?.id {
                    DDCStoreOptionsAPIManager.getStoreOptions(currentStoreId: modelId, successHandler: { (array) in
                        stores = array
                        workingGroup.leave()
                    }, failHandler: { (error) in
                        workingGroup.leave()
                    })
                }
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCContractDetailsAPIManager.getContractPackageInfo(detailId: detailId, successHandler: { (response) in
                package = response
                workingGroup.leave()
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCEditClientInfoAPIManager.availableChannels(successHandler: { (array) in
                channels = array
                workingGroup.leave()
            }, failHandler: { (error) in
                workingGroup.leave()
            })
        }
        
        workingGroup.notify(queue: workingQueue) {
            result = (model, channels, stores, package)
            successHandler(result)
        }
    }
    
    class func getContractDetails(detailId : Int ,successHandler: @escaping (_ result : DDCContractModel) -> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/detail.do")
        let param : Dictionary = ["id":detailId]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            if case let data as Dictionary<String, Any> = tuple.data!["userContract"] {
                let contractDetail : DDCContractModel = DDCContractModel(JSON: data)!
                if let userData = data["user"],
                    let user = userData as? Dictionary<String, Any>{
                    contractDetail.customer = DDCCustomerModel(JSON: user)
                }
                if let storeData = data["currentCourseAddress"],
                    let store = storeData as? Dictionary<String, Any>{
                    contractDetail.currentStore = DDCStoreModel(JSON: store)
                }
                contractDetail.status = DDCContractStatus(rawValue: UInt(data["status"] as! String)!)
                contractDetail.payMethod = DDCPayMethod(rawValue: UInt(data["payMethod"] as! String)!)
                successHandler(contractDetail)
            }
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getContractPackageInfo(detailId : Int ,successHandler: @escaping (_ response:(packageName: String, packageCategoryName: String, singleStore: Bool) )-> (), failHandler: @escaping (_ error : String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/packageskuincontractdetial.do")
        let param : Dictionary = ["id":detailId]
        DDCHttpSessionsRequest.callPostRequest(url: url, parameters: param, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            if case let data as Dictionary<String, Any> = tuple.data {
                let packageName : String = data["packageName"] as! String
                let packageCategoryName : String = data["skuName"] as! String
                let singleStore : Bool = data["addressUseType"] as! Int == 1 ? true : false
                let response = (packageName, packageCategoryName, singleStore)
                successHandler(response);
            }
        }) { (error) in
            failHandler(error)
        }
    }
   
}
