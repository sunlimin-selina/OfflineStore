//
//  DDCContractDetailsViewModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/23.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCContractDetailsViewModel: NSObject {
    var title: String?
    var describe: String?
    var paragraph: NSParagraphStyle?
    
    init(title: String?, describe: String?) {
        super.init()
        self.title = title
        self.describe = describe
    }
    
}

class DDCContractDetailsViewModelFactory: NSObject {
    
    class func integrateData(category: Categorys) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()

        //合同编号
        let code: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "合同编号", describe: category.model?.code)
        //合同状态
        let modelStatus: Int = Int((category.model?.status)!.rawValue)
        let status: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "合同状态", describe: ((category.model?.status != .all) ? DDCContract.backendStatusArray[modelStatus] : ""))
        //姓名
        let name: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "姓名", describe: category.model?.customer?.nickName)
        //性别
        let gender: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "性别", describe: category.model?.customer?.sex?.rawValue)
        //年龄
        let age: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "年龄", describe: category.model!.customer!.age != nil ? category.model!.customer!.age!.appendingFormat("岁") : "")
        //生日
        let birthday: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生日", describe: category.model!.customer!.formattedBirthday)
        //手机号码
        let phoneNumber: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "手机号码", describe: category.model!.customer!.userName)
        //职业
        let career: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "职业", describe:"")//category.model!.customer!.career!.rawValue
        //邮箱
        let email: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "邮箱", describe:category.model!.customer!.email)
        //渠道
//            [self channelViewModel],
//            [self packageViewModel],//产品套餐
//            [self courseViewModel],//产品规格
        //生效期限
        let startTime: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生效期限", describe:"")//(self.contractModel.subContract.startTime && self.contractModel.subContract.endTime) ? [NSString stringWithFormat:@"%@-%@",self.contractModel.subContract.startTime,self.contractModel.subContract.endTime] : @""
        //有效时间
        let effectiveTime: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "有效时间", describe:category.model!.subContract?.effectiveTime)
        
//            [self effectiveStoresViewModel],
        //支付方式
        let payMethod: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付方式", describe:"")//[DDCContractDetailsModel payMethodArr][_payMethod]
        //当前门店
        let currentStore: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe:category.model!.currentStore!.title)
        //支付金额
        let contractPrice: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:"")//self.contractModel.contractPrice ? [NSString stringWithFormat:@"¥%@", [self.numberFormatter stringFromNumber:self.contractModel.contractPrice]] : @""]
        //签单员工
        let signedUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:category.model!.signedUsername)
        //责任销售
        let responsibleUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "责任销售", describe:category.model!.responsibleUsername)
        //业绩归属
        let createdUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "业绩归属", describe:category.model!.createdUsername)
        array = [code, status, name, gender, age, birthday, phoneNumber, career, email, startTime, effectiveTime, payMethod, currentStore, contractPrice, signedUsername, responsibleUsername, createdUsername]
        return array
    }
    
}
