//
//  DDCContractDetailsModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractListModel: Mappable {
    var mobile: String?
    var lineUserName: String?
    var contractId: CLong?
    var code: String?
    var title: String?
    var status: DDCContractStatus?
    var salePrice: Double?
    var createTime: Int?
    var type: DDCContractType?

    init() {
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        mobile <- map["mobile"]
        lineUserName <- map["lineUserName"]
        contractId <- map["contractId"]
        code <- map["code"]
        
        title <- map["title"]
        status <- map["status"]
        salePrice <- map["salePrice"]
        createTime <- map["createTime"]
        type <- map["type"]
    }
}
