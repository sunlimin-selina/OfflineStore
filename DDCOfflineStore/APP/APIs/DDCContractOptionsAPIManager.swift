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
    class func packagesForContract(storeId: Int, type: DDCContractType, successHandler: @escaping (_ result: [DDCContractPackageModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/package/list.do")
        let params: Dictionary<String, Any> = ["addressId": storeId ,"type": type.rawValue]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let packagesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let packages:[DDCContractPackageModel] = Mapper<DDCContractPackageModel>().mapArray(JSONArray: packagesArray)
                successHandler(packages)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getCourseSpec(packageId: Int, successHandler: @escaping (_ result: [DDCContractPackageCategoryModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/package/sku/list.do")
        let params = ["packageId": packageId]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let coursesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let courses:[DDCContractPackageCategoryModel] = Mapper<DDCContractPackageCategoryModel>().mapArray(JSONArray: coursesArray)
                successHandler(courses)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getCustomCourse(storeId: Int, successHandler: @escaping (_ result: [DDCCourseModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/category/shop-list.do")
        let params = ["addressId": storeId]
        
        DDCHttpSessionsRequest.callGetRequest(url: url, parameters: params, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let coursesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let courses:[DDCCourseModel] = Mapper<DDCCourseModel>().mapArray(JSONArray: coursesArray)
                successHandler(courses)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getSampleCourse(storeId: Int, successHandler: @escaping (_ result: [DDCCourseModel]?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/course/experience-list.do")

        DDCHttpSessionsRequest.callGetRequest(url: url, success: { (response) in
            let tuple = DDCHttpSessionsRequest.filterResponseData(response: response)
            guard tuple.code == 200 else{
                failHandler(tuple.message)
                return
            }
            if !DDCTools.isBlankObject(object: tuple.data) ,
                case let coursesArray: [[String : Any]] = tuple.data as! [[String : Any]] {
                let courses:[DDCCourseModel] = Mapper<DDCCourseModel>().mapArray(JSONArray: coursesArray)
                successHandler(courses)
                return
            }
            successHandler(nil)
        }) { (error) in
            failHandler(error)
        }
    }
    
    class func getGroupCourse(storeId: Int, successHandler: @escaping (_ result: (customCourses: [DDCCourseModel]?, sampleCourses: [DDCCourseModel]?)?) -> (), failHandler: @escaping (_ error: String) -> ()) {
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        var result: (customCourses: [DDCCourseModel]?, sampleCourses: [DDCCourseModel]?)
        var customCourses: [DDCCourseModel]?
        var sampleCourses: [DDCCourseModel]?
        var errorMessage: String?

        workingGroup.enter()
        workingQueue.async {
            DDCContractOptionsAPIManager.getCustomCourse(storeId: storeId, successHandler: { (array) in
                customCourses = array
                workingGroup.leave()
            }) { (error) in
                errorMessage = error
                workingGroup.leave()
            }
        }
        
        workingGroup.enter()
        workingQueue.async {
            DDCContractOptionsAPIManager.getSampleCourse(storeId: storeId, successHandler: { (models) in
                sampleCourses = models
                workingGroup.leave()
            }, failHandler: { (error) in
                errorMessage = error
                workingGroup.leave()
            })
        }
        
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                // 主线程中
                if let _customCourses = customCourses ,
                    let _sampleCourses = sampleCourses{
                    result = (_customCourses, _sampleCourses)
                    successHandler(result)
                } else {
                    failHandler(errorMessage ?? "")
                }
            }
        }
    }
}
