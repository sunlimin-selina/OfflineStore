//
//  DDCContractStatus.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

enum DDCContractStatus : UInt{
    case all
    case effective//生效中
    case ineffective//未生效
    case inComplete//未完成
    case completed//已结束
    case revoked//已解除
    case used//已核销
}

enum DDCCourseType {
    case none
    case regular // 正式课程
    case sample  // 体验课程
}
