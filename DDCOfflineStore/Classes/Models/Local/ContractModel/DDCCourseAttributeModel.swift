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
    
    var attributeValueId: Int?
    var categoryId: Int?
    var attributeValue: String?

    override func mapping(map: Map) {
        attributeValueId <- map["attributeValueId"]
        attributeValue <- map["attributeValue"]
        categoryId <- map["categoryId"]
    }
    
}
