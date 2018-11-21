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
    var categoryName: String?
    var attributes: [DDCCourseAttributeModel]?
    var courseName: String?

    override func mapping(map: Map) {
        courseid <- map["id"]
        categoryName <- map["categoryName"]
        attributes <- map["attribute"]
        courseName <- map["courseName"]
    }
    
}
