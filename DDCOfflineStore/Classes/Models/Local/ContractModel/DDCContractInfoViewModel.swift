//
//  DDCContractInfoViewModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCContractInfoViewModel: NSObject {
    
    enum DDCContractInfoModelType : Int{
        case textField
        case checked
    }
    
    var title: String?
    var placeholder: String?
    var text: String?
    
    var isFill: Bool?
    var isRequired: Bool?
    var tag: UInt?

    var type: DDCContractInfoModelType?
    var courseArr: [DDCOffLineCourseModel]?
    
    
    init(title: String, placeholder: String, text: String, isRequired: Bool, tag: UInt) {
        super.init()
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.isRequired = isRequired
        self.tag = tag
    }
    
    init(title: String, placeholder: String, text: String, isRequired: Bool, tag: UInt, type: DDCContractInfoModelType) {
        super.init()
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.isRequired = isRequired
        self.tag = tag
        self.type = type
    }
}
