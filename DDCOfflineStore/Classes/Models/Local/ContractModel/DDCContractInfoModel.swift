//
//  DDCContractInfoModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/17.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractInfoModel: Mappable {
    var id: Int?
    var contractNo: String?
    var course: Array<DDCOffLineStoreModel>?
    var startTime: String?
    var endTime: String?
    var effectiveTime: String?
    var contractPrice: String?
    var createDate: Int?
    var createDateString: String?
    var realCreateUserName: String?
    var belongCreateUserName: String?
    var effectiveCourseAddress: DDCOffLineStoreModel?
    var currentCourseAddress: DDCOffLineStoreModel?

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        contractNo <- map["contractNo"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        effectiveTime <- map["effectiveTime"]
        
        contractPrice <- map["contractPrice"]
        createDate <- map["createDate"]
        realCreateUserName <- map["realCreateUserName"]
        belongCreateUserName <- map["belongCreateUserName"]
        
//        self.createDateString = DDCTools.date(from: self.createDate!)
    }
    
}
