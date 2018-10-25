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
    var color : UIColor?

    init(title: String?, describe: String?) {
        super.init()
        self.title = title
        self.describe = describe
        self.color = DDCColor.fontColor.black
    }
    
    init(title: String?, describe: String?, color: UIColor?) {
        super.init()
        self.title = title
        self.describe = describe
        self.color = color
    }
}

class DDCContractDetailsViewModelFactory: NSObject {
    
    class func integrateData(category: Categorys) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()

        //合同编号
        let code: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "合同编号", describe: category.model?.code)
        //合同状态
        let modelStatus: UInt = UInt((category.model?.status)!.rawValue)
        let statusModel: DDCStatusViewModel = DDCContract.statusPairings[modelStatus]!
        let status: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "合同状态", describe: ((category.model?.status != .all) ? statusModel.title : ""), color: statusModel.color)
        //姓名
        let name: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "姓名", describe: category.model?.customer?.nickName)
        //性别
        let sex: Int = (category.model?.customer?.sex?.rawValue)!
        let gender: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "性别", describe: DDCContract.genderArray[sex])//
        
        //年龄
        let age: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "年龄", describe: category.model!.customer!.age != nil ? category.model!.customer!.age!.appendingFormat("岁") : "")
        //生日
        let birthday: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生日", describe: category.model!.customer!.formattedBirthday)
        //手机号码
        let phoneNumber: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "手机号码", describe: category.model!.customer!.userName)
        //职业
        let careerIndex: Int = Int(category.model!.customer!.career!)!
        let career: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "职业", describe:DDCContract.occupationArray[careerIndex])
        //邮箱
        let email: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "邮箱", describe:category.model!.customer!.email)
        //渠道
        let channel: DDCContractDetailsViewModel = DDCContractDetailsViewModelFactory.channelViewModel(category: category)
        //产品套餐
        let package: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "产品套餐", describe: category.package?.packageName ?? "")
        //产品规格
        let course: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "产品规格", describe: category.package?.packageCategoryName ?? "")
        //生效期限
        let term: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生效期限", describe:"\(category.model!.subContract!.startTime!) -\(category.model!.subContract!.endTime!)")
        //有效时间
        let effectiveTime: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "有效时间", describe:category.model!.subContract?.effectiveTime)
        //有效门店
        let store: DDCContractDetailsViewModel = DDCContractDetailsViewModelFactory.effectiveStoresViewModel(stores: category.stores)
        //支付方式
        let payIndex: Int = category.model!.payMethod!.rawValue
        let payMethod: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付方式", describe:DDCContract.payMethodArray[payIndex])
        //当前门店
        let currentStore: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe:category.model!.currentStore!.title)
        //支付金额
        let price : String = "¥\(category.model!.contractPrice ?? "")"
        let contractPrice: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:price)
        //签单员工
        let signedUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:category.model!.signedUsername)
        //责任销售
        let responsibleUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "责任销售", describe:category.model!.responsibleUsername)
        //业绩归属
        let createdUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "业绩归属", describe:category.model!.createdUsername)
        array = [code, status, name, gender, age, birthday, phoneNumber, career, email, channel, package, course, term, effectiveTime, store, payMethod, currentStore, contractPrice, signedUsername, responsibleUsername, createdUsername]
        return array
    }
 
    class func channelViewModel(category: Categorys) -> DDCContractDetailsViewModel{
        if let array = category.channels{
            let channels : NSArray = array as NSArray
            let idx : Int = channels.indexOfObject { (channelModel, idx, stop) -> Bool in
                if let object = channelModel as? DDCChannelModel{
                    return object.id == category.model?.customer?.channel?.intValue
                }
                return false
            }
            let channel: DDCChannelModel? = (idx != NSNotFound) ? (channels[idx] as! DDCChannelModel) : nil
            
            return DDCContractDetailsViewModel.init(title: "渠道", describe: channel != nil ? channel!.name : "")
        }
        return DDCContractDetailsViewModel.init(title: "渠道", describe:"")
    }
    
    class func effectiveStoresViewModel(stores: [DDCStoreModel]?) -> DDCContractDetailsViewModel {
        if let _stores = stores {
            var storeName : String = ""
            for index in 0...(_stores.count - 1) {
                let store: DDCStoreModel = _stores[index]
                if index != 0 ,
                    index % 3 == 0 {
                    storeName = storeName + "\(store.title ?? "") \n"
                } else {
                    storeName = storeName + "\(store.title ?? ""), "
                }
            }
//            storeName.replacingCharacters(in: NSMakeRange(storeName.count - 2, 2), with: "")
            return DDCContractDetailsViewModel.init(title: "有效门店", describe: storeName)
        }
 
        return DDCContractDetailsViewModel.init(title: "有效门店", describe: "")
    }
}
