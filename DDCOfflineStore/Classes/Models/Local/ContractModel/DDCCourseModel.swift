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
    
    class func aidata() -> [DDCCourseModel] {
        let sweet: DDCCourseModel = DDCCourseModel.init()
        let sweetAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        sweetAttribute.attributeValueId = 4
        sweetAttribute.attributeValue = "初级"
        sweetAttribute.categoryId = 1
        sweet.id = 1
        sweet.categoryName = "甜点"
        sweet.attributes = [sweetAttribute]
        
        let pam: DDCCourseModel = DDCCourseModel.init()
        let pamAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        pamAttribute.attributeValueId = 4
        pamAttribute.attributeValue = "中级"
        pamAttribute.categoryId = 1
        let middleAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        middleAttribute.attributeValueId = 4
        middleAttribute.attributeValue = "高级"
        middleAttribute.categoryId = 1
        let sAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        sAttribute.attributeValueId = 4
        sAttribute.attributeValue = "初级"
        sAttribute.categoryId = 1
        pam.id = 2
        pam.categoryName = "南瓜"
        pam.attributes = [pamAttribute,middleAttribute,sAttribute]
        
        let qse: DDCCourseModel = DDCCourseModel.init()
        let qseAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        qseAttribute.attributeValueId = 4
        qseAttribute.attributeValue = "中级"
        qseAttribute.categoryId = 1
        let qsemiddleAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        qsemiddleAttribute.attributeValueId = 4
        qsemiddleAttribute.attributeValue = "高级"
        qsemiddleAttribute.categoryId = 1
        let qsehAttribute: DDCCourseAttributeModel = DDCCourseAttributeModel.init()
        qsehAttribute.attributeValueId = 4
        qsehAttribute.attributeValue = "初级"
        qsehAttribute.categoryId = 1
        qse.id = 2
        qse.categoryName = "冬瓜"
        qse.attributes = [qseAttribute,qsemiddleAttribute,qsehAttribute]
        return [sweet,pam,qse]
    }
}
