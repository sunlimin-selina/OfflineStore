//
//  DDCEditClientInfoModelFactory.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCEditClientInfoModelFactory: NSObject {
    class func integrateData(model: DDCContractModel?) -> [DDCContractInfoViewModel] {
        var array: [DDCContractInfoViewModel] = Array()
        //手机号码
        let phoneNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "手机号码", placeholder: "请输入手机号码", text: "", isRequired: true, tag: 0)
        //姓名
        let name: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "姓名", placeholder: "请输入姓名", text: "", isRequired: true, tag: 0)
        //性别
        let gender: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "性别", placeholder: "请选择性别", text:"", isRequired: true, tag: 0)
        //生日
        let birthday: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生日", placeholder: "请输入生日", text: "", isRequired: true, tag: 0)
        //年龄
        let age: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "年龄", placeholder: "年龄", text:"", isRequired: true, tag: 0)
        //邮箱
        let email: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "邮箱", placeholder: "邮箱", text: "", isRequired: true, tag: 0)
        //渠道
        let channel: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "渠道", placeholder: "请选择渠道", text:"", isRequired: true, tag: 0)

        array = [phoneNumber, name, gender, birthday, age, email, channel]
        return array
    }
}
