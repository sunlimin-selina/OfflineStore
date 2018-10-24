//
//  DDCSubContractModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCSubContractModel: Mappable {
    var id: String?
    var startTimestamp: Int?
    var endTimestamp: Int?
    var effectiveTimestamp: Int?

    var startTime: String?
    var endTime: String?
    var effectiveTime: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        startTimestamp <- map["startTime"]
        endTimestamp <- map["endTime"]
        effectiveTimestamp <- map["effectiveTime"]
        
        self.startTime = (self.startTimestamp != nil) ? DDCTools.date(from: self.startTimestamp!): ""
        self.endTime = (self.endTimestamp != nil) ?  DDCTools.date(from: self.endTimestamp!) : ""
        self.effectiveTime = (self.effectiveTimestamp != nil) ?  DDCTools.date(from:self.effectiveTimestamp!) : ""
    }
    
}
