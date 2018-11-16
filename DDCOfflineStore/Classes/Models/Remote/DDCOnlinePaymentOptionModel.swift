//
//  DDCOnlinePaymentOptionModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCOnlinePaymentOptionModel: Mappable {
    var code_url: String?
    var out_trade_no: String?
    var qr_code: String?

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        code_url <- map["code_url"]
        out_trade_no <- map["out_trade_no"]
        qr_code <- map["qr_code"]
    }
}
