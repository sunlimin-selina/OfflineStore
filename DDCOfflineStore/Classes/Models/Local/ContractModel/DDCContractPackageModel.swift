//
//  DDCContractPackageModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractPackageModel: Mappable {
    
    enum DDCRegularCoursePurchaseType {
        case none
        case category // 按分类
        case frequency  // 按次数
        case aging // 按时效
    }

    var packageType: DDCRegularCoursePurchaseType?
    var customSkuConfig: Int?//自选套餐标志(1自选)
    var modifySkuPrice: Bool?//修改金额标志
    var addressUseType: Bool?//是否单店有效标志，0是单店

    var virtualSkuList: Array<Any>?
    var startUseTime: CLong?
    var beginDate: NSDate?
    var upgradeLimit: Int?
    var courseType: DDCCourseType?//课程类型，正式课程1，体验课程2

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        packageType <- map["packageType"]
        customSkuConfig <- map["customSkuConfig"]
        modifySkuPrice <- map["modifySkuPrice"]
        addressUseType <- map["addressUseType"]
        
        virtualSkuList <- map["virtualSkuList"]
        startUseTime <- map["startUseTime"]
        beginDate <- map["beginDate"]
        upgradeLimit <- map["upgradeLimit"]
        
        courseType <- map["courseType"]

    }
    
}
