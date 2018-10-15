//
//  DDCStoreModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCStoreModel: NSObject {
    var ID: String?
    var title: String?
    
    class func model(with title: String, ID: String) -> DDCContractTypeModel {
        let model: DDCContractTypeModel = DDCContractTypeModel()
        model.ID = ID
        model.title = title
        return model
    }
}
