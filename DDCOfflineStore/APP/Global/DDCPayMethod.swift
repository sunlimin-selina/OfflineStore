//
//  DDCPayMethod.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/17.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

enum DDCPayMethod: UInt , Codable{
    case none
    case zhifubao
    case weixin
    case cash
}