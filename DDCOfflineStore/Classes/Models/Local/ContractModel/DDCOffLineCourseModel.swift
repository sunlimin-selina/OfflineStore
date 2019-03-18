//
//  DDCOffLineCourseModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCOffLineCourseModel: NSObject {
    var id: String?
    var isChecked: Bool?
    var count: String?
    var categoryName: String?
    var attributes: [DDCOffLineCourseAttributeModel]?
}

class DDCOffLineCourseAttributeModel: NSObject {
    var id: String?
    var isChecked: Bool?
    var count: String?
    var attributeValue: String?
}
