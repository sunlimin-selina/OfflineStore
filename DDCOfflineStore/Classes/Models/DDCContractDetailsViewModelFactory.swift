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
    var color: UIColor?

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

        //订单编号
        let code: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "订单编号", describe: category.model?.code)
        //订单状态
        let modelStatus: UInt = UInt((category.model?.status)!.rawValue)
        let statusModel: DDCStatusViewModel = DDCContract.statusPairings[modelStatus]!
        let status: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "订单状态", describe: ((category.model?.status != .all) ? statusModel.title: ""), color: statusModel.color)
        //姓名
        let name: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "姓名", describe: category.model?.customer?.name)
        //性别
        let sex: String = (category.model?.customer?.sex != nil) ? DDCContract.genderArray[((category.model?.customer?.sex!.rawValue)!)]: ""
        let gender: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "性别", describe: sex)
        //年龄
        let birthdayD = DDCTools.datetime(from: category.model!.customer!.birthday!)
        let components = Calendar.current.dateComponents([.year], from: birthdayD, to: Date())
        let age: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "年龄", describe: (components.year != nil) ? "\(components.year!)岁": "")
        //生日
        let birthday: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生日", describe: category.model!.customer!.formattedBirthday)
        //手机号码
        let phoneNumber: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "手机号码", describe: category.model!.customer!.mobile)
        //职业
        let userCareer: String = (category.model?.customer?.career != nil) ? DDCContract.occupationArray[(category.model!.customer!.career?.rawValue)!]: ""
        let career: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "职业", describe:userCareer)
        //邮箱
        let email: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "邮箱", describe:category.model!.customer!.email)
        //顾客渠道
        let channel: DDCContractDetailsViewModel = DDCContractDetailsViewModelFactory.channelViewModel(category: category)
        //介绍会员
        let recommendUser: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "介绍会员", describe: category.package?.packageName ?? "")
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
        let payIndex: Int = (category.model!.payMethod != nil) ? category.model!.payMethod!.rawValue: 0
        let payMethod: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付方式", describe:DDCContract.payMethodArray[payIndex])
        //当前门店
        let currentStore: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe:(category.model!.currentStore != nil && category.model!.currentStore!.title != nil) ? category.model!.currentStore!.title: "")
        //支付金额
        let price: String = "¥\(category.model!.contractPrice ?? "")"
        let contractPrice: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:price)
        //签单员工
        let signedUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "签单员工", describe:category.model!.signedUsername)
        //责任销售
        let responsibleUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "责任销售", describe:category.model!.responsibleUsername)
        //业绩归属
        let createdUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "业绩归属", describe:category.model!.createdUsername)
        array = [code, status, name, gender, age, birthday, phoneNumber, career, email, channel, recommendUser, package, course, term, effectiveTime, store, payMethod, contractPrice, currentStore, signedUsername, responsibleUsername, createdUsername]
        return array
    }
    
    class func integrateUserData(category: Array<String>?) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()
        
        //当前客户
        let customer: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前客户", describe: "")
        //客户手机
        let phone: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户手机", describe: "")
        //客户类型
        let type: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户类型", describe: "")
        //进行订单
        let order: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "进行订单", describe: "")
        //全部订单
        let allOrder: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "全部订单", describe: "")
        //约课次数
        let times: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "约课次数", describe: "")
        //最后课程
        let finishCourse: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "最后课程", describe: "")
       
        array = [customer, phone, type, order, allOrder, times, finishCourse]
        return array
    }
    
    class func integrateContractData(model: DDCContractModel?) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()
        
        //当前客户
        let customer: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前客户", describe: model?.customer?.mobile)
        //客户手机
        let phone: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户手机", describe: model?.customer?.name)
        //当前门店
        let store: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe: model?.currentStore?.title)
        //销售类型
        let contractType: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "销售类型", describe: "")
        
        array = [customer, phone, store, contractType]
        return array
    }
 
    class func channelViewModel(category: Categorys) -> DDCContractDetailsViewModel{
        if let array = category.channels{
            let channels: NSArray = array as NSArray
            
            if let channelId = category.model?.customer?.channelCode{
                let idx: Int = channels.indexOfObject { (channelModel, idx, stop) -> Bool in
                    if let object = channelModel as? DDCChannelModel{
                        return object.id == Int(channelId)
                    }
                    return false
                }
                let channel: DDCChannelModel? = (channels[idx] as! DDCChannelModel)
                var string = category.model?.customer?.channelDesc
                if string != nil,
                    (string!.count) > 0 {
                    string = "\(channel!.name ?? "")-\(category.model!.customer!.channelDesc!)"
                } else {
                    string = channel!.name ?? ""
                }
                return DDCContractDetailsViewModel.init(title: "顾客渠道", describe:channel != nil ? string: "")
            }
        }
        return DDCContractDetailsViewModel.init(title: "顾客渠道", describe:"")
    }
    
    class func effectiveStoresViewModel(stores: [DDCStoreModel]?) -> DDCContractDetailsViewModel {
        if let _stores = stores {
            var storeName: String = ""
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
