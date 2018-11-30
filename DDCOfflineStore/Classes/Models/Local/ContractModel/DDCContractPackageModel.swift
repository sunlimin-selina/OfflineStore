//
//  DDCContractPackageModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractPackageModel: DDCCheckBoxModel {
    
    enum DDCRegularCoursePurchaseType: Int {
        case none
        case category // 按分类
        case frequency  // 按次数
        case aging // 按时效
        case limited // 限制课程
    }

    var code: String?
    var name: String?
    var courseType: DDCCourseType = .regular
    var startUseTime: CLong?
    var endEffectiveTime: CLong?

    var brand: Int?
    
    var packageType: DDCRegularCoursePurchaseType?
    var customSkuConfig: Int?//自选套餐标志(1自选)
    var modifySkuPrice: Bool?//修改金额标志

    var upgradeLimit: Int?
    var courseLimit: Int?
    var addressUseType: Int?

    override func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        name <- map["name"]
        courseType <- map["type"]
        startUseTime <- map["startUseTime"]
        brand <- map["brand"]

        packageType <- map["packageType"]
        customSkuConfig <- map["customSkuConfig"]
        modifySkuPrice <- map["modifySkuPrice"]
        addressUseType <- map["addressUseType"]
        
        upgradeLimit <- map["upgradeLimit"]
        courseLimit <- map["courseLimit"]
    }
//
//    func getVirtualSkuList(array: Array<Any>?) -> [DDCContractPackageCategoryModel] {
//        if array!.count > 0 {
//            var list: Array<Any> = Array()
//            for data in array! {
//                if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
//                    let model: DDCContractPackageCategoryModel = DDCContractPackageCategoryModel(JSON: _data)!
//                    list.append(model)
//                }
//            }
//            return list as! [DDCContractPackageCategoryModel]
//        }
//       return []
//    }
}

class DDCContractPackageCategoryModel: DDCCheckBoxModel {
    var name: String?
    var code: String?

    var salePrice: Int?
    var activityPrice: Int?
    var costPrice: Double?
    
    var effectiveCount: Int?
    var haveTimeLimit: Int?
    var validPeriod: Int?
    var validPeriodType: Int?
    var haveUseRule: Int?

    override func mapping(map: Map) {
        id <- map["id"]

        name <- map["name"]
        code <- map["code"]

        salePrice <- map["salePrice"]
        activityPrice <- map["activityPrice"]
        costPrice <- map["costPrice"]

        effectiveCount <- map["effectiveCount"]
        validPeriod <- map["validPeriod"]
        haveUseRule <- map["haveUseRule"]
        validPeriodType <- map["validPeriodType"]
        haveTimeLimit <- map["haveTimeLimit"]
        
        costPrice = costPrice! / 100
    }
}
