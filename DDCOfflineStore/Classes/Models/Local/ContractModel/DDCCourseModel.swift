//
//  DDCCourseModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCCourseModel: DDCCheckBoxModel {
    
    var courseid: Int?
    var count: Int?
    var categoryName: String?
    var attributes: [DDCCourseAttributeModel]?

    override func mapping(map: Map) {
        courseid <- map["id"]
        categoryName <- map["categoryName"]
        count <- map["name"]
        attributes <- map["optionAttributeValueList"]
    }
    
}
