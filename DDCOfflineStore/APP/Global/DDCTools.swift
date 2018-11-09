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
        let loadingView = DDCLoadingView.sharedLoading()
        if loadingView.constraints.count > 0{
            loadingView.removeFromSuperview()
        }
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        loadingView.runAnimation()
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
    
    class func datetime(from timeInterval: Int) -> Date {
        let _dateFormatter : DateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let timeInterval : TimeInterval = TimeInterval.init(Double(timeInterval))
        let date : NSDate = NSDate.init(timeIntervalSince1970: timeInterval / 1000)
        return date as Date
    }
    
    class func date(from dateString: String) -> Int {
        let _dateFormatter : DateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let date : Date = _dateFormatter.date(from: dateString)!
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp: Int = Int(timeInterval)
        return timeStamp
    }
    
    class func validateString(string: String) -> Bool {
        let rule: String = "[\\u4e00-\\u9fa5a-zA-Z]+[\\u4e00-\\u9fa5a-zA-Z\\s]*[\\u4e00-\\u9fa5a-zA-Z]+"
        return NSPredicate.init(format: "SELF MATCHES %@", rule).evaluate(with: string)
    }
    
    class func validateEmail(email: String) -> Bool {
        let rule: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate.init(format: "SELF MATCHES %@", rule).evaluate(with: email)
    }
    
    class func splitPhoneNumber(string: String, length: Int) -> String {
        var noBlankString: String = string.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        // 插入空格
        if length >= 4,
            length <= 8 {
            noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 3))
        } else if(length > 8) {
            noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 3))
            noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 8))
        }
        return noBlankString
    }
}
