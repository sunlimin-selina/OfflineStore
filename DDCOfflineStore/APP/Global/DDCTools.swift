//
//  DDCTools.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class DDCTools: NSObject{
    
    static func isPhoneNumber(number: String?) -> Bool {
        if number != nil {
            let mobile = "^1[345789]{1}\\d{9}$"
            return NSPredicate.init(format: "SELF MATCHES %@", mobile).evaluate(with: number)
        }
        return false
    }

    static func validateString(string: String) -> Bool {
        let rule: String = "[\\u4e00-\\u9fa5a-zA-Z]+[\\u4e00-\\u9fa5a-zA-Z\\s]*[\\u4e00-\\u9fa5a-zA-Z]+"
        return NSPredicate.init(format: "SELF MATCHES %@", rule).evaluate(with: string)
    }
    
    static func validateEmail(email: String) -> Bool {
        let rule: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate.init(format: "SELF MATCHES %@", rule).evaluate(with: email)
    }
    
    static func splitPhoneNumber(string: String, length: Int) -> String {
        var noBlankString: String = string.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)

        if noBlankString.count > 0 {
            // 插入空格
            if length >= 4,
                length <= 8 {
                noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 3))
            } else if(length > 8) {
                noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 3))
                noBlankString.insert(" ", at: noBlankString.index(noBlankString.startIndex, offsetBy: 8))
            }
        }
        return noBlankString
    }
    
    static func removeWhiteSpace(string: String) -> String {
        let noBlankString: String = string.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        return noBlankString
    }
    
    static func isQualifiedCode(qrCode: String?) -> Bool {
        if let _qrCode = qrCode {
            let array = _qrCode.components(separatedBy:"-")
            if array.count > 2 {
                return true
            }
        }
        return false
    }
 
    static func isRightCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied
    }

    static func isBlankObject(object: AnyObject?) -> Bool {
        if object != nil, !(object!.isKind(of: NSNull.self)) {
            return false
        }
        return true
    }
}

//MARK: -Date
extension DDCTools {
    
    static func date(from timeInterval:Int) -> String {
        let _dateFormatter: DateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy/MM/dd"

        let timeInterval: TimeInterval = TimeInterval.init(Double(timeInterval))
        let date: NSDate = NSDate.init(timeIntervalSince1970: timeInterval / 1000)
        return _dateFormatter.string(from: date as Date)
    }
    
    static func datetime(from timeInterval: Int?) -> Date {
        var interval: TimeInterval = Date().timeIntervalSince1970
        if let _timeInterval = timeInterval {
            interval = TimeInterval.init(Double(_timeInterval))
        }
        let date: Date = Date.init(timeIntervalSince1970: interval / 1000)
        return date
    }
    
    static func date(from dateString: String) -> Int {
        var date: Date = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month, .day], from: date)
        date = calendar.date(from: dateComponents)!
        
        if dateString.count > 0 {
            let _dateFormatter: DateFormatter = DateFormatter()
            _dateFormatter.dateFormat = "yyyy/MM/dd"
            date = _dateFormatter.date(from: dateString)!
        }
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp: Int = Int(timeInterval)
        let timeIntervalS: String = "\(timeStamp * 1000)"
        return Int(timeIntervalS)!
    }
    
    static func dateToTimeInterval(from date: Date) -> Int {
        let _dateFormatter: DateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = _dateFormatter.string(from: date as Date)
        let timeStamp: Int = Int(DDCTools.date(from: dateString))
        return timeStamp
    }
}

//MARK: -HUD
extension DDCTools {
    
    static func showHUD(view: UIView){
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
    
    static func hideHUD() {
        DDCLoadingView.sharedLoading().removeFromSuperview()
    }
    
}
