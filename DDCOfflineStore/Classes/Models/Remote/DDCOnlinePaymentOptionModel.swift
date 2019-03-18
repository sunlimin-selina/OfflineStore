//
//  DDCOnlinePaymentOptionModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCOnlinePaymentOptionModel: NSObject, Mappable {
    var contractNo: String?
    var out_trade_no: String?
    var qr_code: String?
    var payOrderNo: String?
    
    override init() {
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        contractNo <- map["contractNo"]
        out_trade_no <- map["out_trade_no"]
        qr_code <- map["qr_code"]
        payOrderNo <- map["payOrderNo"]
    }
}
