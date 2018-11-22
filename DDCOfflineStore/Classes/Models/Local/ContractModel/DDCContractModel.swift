//
//  DDCContractModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractModel: Mappable {

    var id: Int?
    var code: String?
    
    var status: DDCContractStatus?
    var payMethod: DDCPayMethod?
    
    var customer: DDCCustomerModel?
    var contractType: DDCContractTypeModel?
    var currentStore: DDCStoreModel?
    var subContract: DDCSubContractModel?
    var packageModel: DDCContractPackageModel?
    var packageCategoryModel: DDCContractPackageCategoryModel?

    var courseType: DDCCourseType = .regular
    var contractPrice: String?
    var createdUsername: String?
    var signedUsername: String?
    var responsibleUsername: String?
    var relationShops: [DDCStoreModel]?
    
    //当前订单状态
    var contractUseCount: Int?
    var contractAllCount: Int?
    var reservationCount: Int?
    var lastCourseName: String?
    
    let payMethodTransform = TransformOf<DDCPayMethod, String>(fromJSON: { (value: String?) -> DDCPayMethod? in
        if let _value = value {
            let intValue = Int(value!)
            return DDCPayMethod(rawValue: intValue!)
        }
        return nil
    }, toJSON: { (value: DDCPayMethod?) -> String? in
        if let value = value?.rawValue {
            return String(value)
        }
        return nil
    })

    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {

        id <- map["id"]
        code <- map["contractNo"]
        
        status <- map["showStatus"]
        payMethod <- (map["payMethod"], payMethodTransform)
        customer <- map["user"]
        contractType <- map["contractType"]
        currentStore <- map["currentCourseAddress"]
        
        subContract <- map["subContract"]
        packageModel <- map["packageModel"]
        packageCategoryModel <- map["packageCategoryModel"]
        courseType <- map["courseType"]
        contractPrice <- map["contractPrice"]
        
        createdUsername <- map["realCreateUserName"]
        signedUsername <- map["belongCreateUserName"]
        responsibleUsername <- map["createUser.name"]
        
        contractUseCount <- map["contractUseCount"]
        contractAllCount <- map["contractAllCount"]
        reservationCount <- map["reservationCount"]
        lastCourseName <- map["lastCourseName"]
    }
    
}
