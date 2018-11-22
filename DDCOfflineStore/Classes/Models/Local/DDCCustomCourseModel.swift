//
//  DDCCustomCourseModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCCustomCourseModel: Mappable {
    
    var categoryId: Int?
    var contractNo: String?
    var courseMasterId: Int?
    var difficulty: String?
    var totalCount: Int?
    var useCount: String?
    var validPeriod: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        categoryId <- map["categoryId"]
        contractNo <- map["contractNo"]
        courseMasterId <- map["courseMasterId"]
        difficulty <- map["difficulty"]
        totalCount <- map["totalCount"]
        useCount <- map["useCount"]
        validPeriod <- map["validPeriod"]
    }
    
}
