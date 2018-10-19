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
        code <- map["code"]
        customer <- map["customer"]
        contractType <- map["contractType"]
        currentStore <- map["currentStore"]
        
        subContract <- map["subContract"]
        packageModel <- map["packageModel"]
        packageCategoryModel <- map["packageCategoryModel"]
        courseType <- map["courseType"]
        contractPrice <- map["contractPrice"]
        
        createdUsername <- map["createdUsername"]
        signedUsername <- map["signedUsername"]
        responsibleUsername <- map["responsibleUsername"]
    }
    
//    func contract(with customer:DDCCustomerModel, model: DDCContractModel) -> DDCContractModel {
//        var _model: DDCContractModel?
//        _model = model
//        _model!.customer = customer
//        return _model!
//    }
//
//    func contract(with ID:String, model: DDCContractModel) -> DDCContractModel {
//        var _model: DDCContractModel?
//        _model = model
//        _model!.customer = customer
//        _model!.ID = ID
//        return _model!
//    }
//
//    func contract(with ID:String, model: DDCContractModel, contractType: DDCContractTypeModel, currentStore: DDCStoreModel) -> DDCContractModel {
//        var _model: DDCContractModel?
//        _model = model
//        _model!.customer = customer
//        _model!.ID = ID
//        _model!.contractType = contractType
//        _model!.currentStore = currentStore
//        return _model!
//    }
    
}
