//
//  DDCTools.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCTools : NSObject{
    
    class func isPhoneNumber(number: String?) -> Bool {
        if number != nil {
            let mobile = "^1[34578]{1}\\d{9}$"
            return NSPredicate.init(format: "SELF MATCHES %@", mobile).evaluate(with: number)
        }
        return false
    }

    class func showHUD(view: UIView){
        view.addSubview(DDCLoadingView.sharedLoading())
        DDCLoadingView.sharedLoading().runAnimation()
        DDCLoadingView.sharedLoading().snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    class func hideHUD() {
        DDCLoadingView.sharedLoading().removeFromSuperview()
    }
    
    class func date(from timeInterval:Int) -> String {
        let _dateFormatter : DateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let timeInterval : TimeInterval = TimeInterval.init(Double(timeInterval))
        let date : NSDate = NSDate.init(timeIntervalSince1970: timeInterval / 1000)
        return _dateFormatter.string(from: date as Date)
    }
}
