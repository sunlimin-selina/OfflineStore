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

    class func showHUD(view: UIView, animated:Bool) -> UIView? {
        if animated == false {
            DDCLoadingView.sharedLoading().removeFromSuperview()
        } else {
            if view != nil {
                view.addSubview(DDCLoadingView.sharedLoading())
                DDCLoadingView.sharedLoading().runAnimation()
                DDCLoadingView.sharedLoading().snp.makeConstraints { (make) in
                    make.edges.equalTo(view)
                }
            }
        }
        return view
    }
}
