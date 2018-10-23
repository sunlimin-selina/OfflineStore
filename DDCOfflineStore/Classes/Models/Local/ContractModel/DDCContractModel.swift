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

    var id : Int?
    var code : String?
    
    var status : DDCContractStatus?
    var payMethod : DDCPayMethod?
    
    var customer : DDCCustomerModel?
    var contractType : DDCContractTypeModel?
    var currentStore : DDCStoreModel?
    var subContract : DDCSubContractModel?
    var packageModel : DDCContractPackageModel?
    var packageCategoryModel : DDCContractPackageCategoryModel?

    var courseType : DDCCourseType?
    var contractPrice : NSDecimalNumber?
    var createdUsername : String?
    var signedUsername : String?
    var responsibleUsername : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        code <- map["contractNo"]
        
        status <- map["status"]
        payMethod <- map["payMethod"]
        customer <- map["customer"]
        contractType <- map["contractType"]
        currentStore <- map["currentStore"]
        
        subContract <- map["subContract"]
        packageModel <- map["packageModel"]
        packageCategoryModel <- map["packageCategoryModel"]
        courseType <- map["courseType"]
        contractPrice <- map["contractPrice"]
        
        createdUsername <- map["realCreateUserName"]
        signedUsername <- map["belongCreateUserName"]
        responsibleUsername <- map["createUser.name"]
    }
    
}
