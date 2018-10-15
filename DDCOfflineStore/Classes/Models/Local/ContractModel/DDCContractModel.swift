//
//  DDCContractModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCContractModel: NSObject {
    var ID : String?
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
    
    func contract(with customer:DDCCustomerModel, model: DDCContractModel) -> DDCContractModel {
        var _model: DDCContractModel?
        _model = model
        _model!.customer = customer
        return _model!
    }
    
    func contract(with ID:String, model: DDCContractModel) -> DDCContractModel {
        var _model: DDCContractModel?
        _model = model
        _model!.customer = customer
        _model!.ID = ID
        return _model!
    }
    
    func contract(with ID:String, model: DDCContractModel, contractType: DDCContractTypeModel, currentStore: DDCStoreModel) -> DDCContractModel {
        var _model: DDCContractModel?
        _model = model
        _model!.customer = customer
        _model!.ID = ID
        _model!.contractType = contractType
        _model!.currentStore = currentStore
        return _model!
    }
    
}
