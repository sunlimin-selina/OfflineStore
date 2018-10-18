//
//  DDCColor.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCColor: UIColor {
    struct mainColor {
        static let orange : UIColor = colorWithHex(RGB: 0xFF5D31)//主色调
        static let alphaOrange : UIColor = colorWithHex(RGB: 0xFF5D31, alpha: 0.66)
    }

    struct fontColor {
        static let gray : UIColor = colorWithHex(RGB: 0xA5A4A4)//字体灰
        static let black : UIColor = colorWithHex(RGB: 0x474747)//字体黑
    }
    
    struct complementaryColor {
        static let separatorColor : UIColor = colorWithHex(RGB: 0xEEEEEE) //分割线
        static let backgroundColor : UIColor = colorWithHex(RGB: 0xF8F8F8)
    }
    
    class func colorWithRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    class func colorWithHex(RGB: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: (((CGFloat)((RGB & 0xFF0000) >> 16))) / 255.0, green: (((CGFloat)((RGB & 0xFF00) >> 8))) / 255.0, blue: (((CGFloat)((RGB & 0xFF)))) / 255.0, alpha: alpha)
    }
    
    class func colorWithHex(RGB: Int)  -> UIColor {
        return DDCColor.colorWithHex(RGB: RGB, alpha: 1.0)
    }
}
