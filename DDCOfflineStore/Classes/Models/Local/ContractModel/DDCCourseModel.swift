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
    var totalCount: Int = 0

    override func mapping(map: Map) {
        courseid <- map["id"]
        categoryName <- map["categoryName"]
        attributes <- map["attribute"]
        courseName <- map["courseName"]
    }
    

    
}

extension DDCCourseModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let courseModel = DDCCourseModel()
        courseModel.id = self.id
        courseModel.title = self.title
        courseModel.discription = self.discription
        courseModel.isSelected = self.isSelected
        courseModel.courseid = self.courseid
        courseModel.categoryName = self.categoryName
        courseModel.attributes = self.attributes
        courseModel.courseName = self.courseName
        courseModel.totalCount = self.totalCount
        return courseModel
    }

}
