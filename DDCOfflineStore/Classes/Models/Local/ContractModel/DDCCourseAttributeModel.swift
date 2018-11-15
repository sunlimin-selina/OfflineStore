//
//  DDCCourseAttributeModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCCourseAttributeModel: DDCCheckBoxModel {
    
    var attributeId: Int?
    var count: Int?
    var attributeValue: String?

    override func mapping(map: Map) {
        attributeId <- map["id"]
        attributeValue <- map["attributeValue"]
        count <- map["sort"]
    }
    
}
