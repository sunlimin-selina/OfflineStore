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
    
    enum DDCRegularCoursePurchaseType {
        case none
        case category // 按分类
        case frequency  // 按次数
        case aging // 按时效
    }

    var name: String?
    var packageType: DDCRegularCoursePurchaseType?
    var customSkuConfig: Int?//自选套餐标志(1自选)
    var modifySkuPrice: Bool?//修改金额标志
    var addressUseType: Bool?//是否单店有效标志，0是单店

    var virtualSkuList: Array<Any>?
    var startUseTime: CLong?
    var beginDate: NSDate?
    var upgradeLimit: Int?
    var courseType: DDCCourseType?//课程类型，正式课程1，体验课程2
    var skuList: [DDCContractPackageCategoryModel]?

    override func mapping(map: Map) {
        name <- map["name"]
        packageType <- map["packageType"]
        customSkuConfig <- map["customSkuConfig"]
        modifySkuPrice <- map["modifySkuPrice"]
        addressUseType <- map["addressUseType"]
        
        virtualSkuList <- map["virtualSkuList"]
        startUseTime <- map["startUseTime"]
        beginDate <- map["beginDate"]
        upgradeLimit <- map["upgradeLimit"]
        
        courseType <- map["courseType"]
        
        skuList = self.getVirtualSkuList(array: virtualSkuList)
    }
    
    func getVirtualSkuList(array: Array<Any>?) -> [DDCContractPackageCategoryModel] {
        if array!.count > 0 {
            var list: Array<Any> = Array()
            for data in array! {
                if let _data: Dictionary<String, Any> = (data as! Dictionary<String, Any>){
                    let model: DDCContractPackageCategoryModel = DDCContractPackageCategoryModel(JSON: _data)!
                    list.append(model)
                }
            }
            return list as! [DDCContractPackageCategoryModel]
        }
       return []
    }
}

class DDCContractPackageCategoryModel: DDCCheckBoxModel {
    var name: String?
    var effectiveCount: Int?
    var costPrice: Int?
    var validPeriod: Int?
    var haveUseRule: Int?

    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        effectiveCount <- map["effectiveCount"]
        costPrice <- map["costPrice"]
        validPeriod <- map["validPeriod"]
        haveUseRule <- map["haveUseRule"]
        
        costPrice = costPrice! / 100
    }
}
