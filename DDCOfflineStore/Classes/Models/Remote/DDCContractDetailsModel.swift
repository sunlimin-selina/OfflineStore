//
//  DDCContractDetailsModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractDetailsModel: Mappable {
    var createUser : DDCUserModel?
    var user : DDCCustomerModel?
    var info : DDCContractInfoModel?
    var showStatus : DDCContractStatus?
    var payMethod : DDCPayMethod?

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        createUser <- map["createUser"]
        user <- map["user"]
        info <- map["info"]
        showStatus <- map["showStatus"]
        payMethod <- map["payMethod"]
    }
}
