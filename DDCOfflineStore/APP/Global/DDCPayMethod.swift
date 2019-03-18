//
//  DDCPayMethod.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/17.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

enum DDCPayMethod: Int{
    case none
    case zhifubao
    case weixin
    case cash
}

enum DDCPaymentStatus: Int {
    case unknown
    case unpaid
    case paid
    case effective
    case overdue
    case cancel
    case used
    case revoke
}
