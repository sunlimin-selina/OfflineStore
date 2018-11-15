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
        static let orange: UIColor = colorWithHex(RGB: 0xFF5D31)//主色调
        static let black: UIColor = colorWithHex(RGB: 0x2F2F2F)
        static let red: UIColor = colorWithHex(RGB: 0xFF5269)
    }

    struct fontColor {
        static let gray: UIColor = colorWithHex(RGB: 0xA5A4A4)//字体灰
        static let black: UIColor = colorWithHex(RGB: 0x474747)//字体黑
        static let thickBlack: UIColor = colorWithHex(RGB: 0x1A1A1A)//字体粗黑
        static let lightGray: UIColor = colorWithHex(RGB: 0x7F7F7F)//字体浅灰
    }
    
    struct complementaryColor {
        static let borderColor: UIColor = colorWithHex(RGB: 0xC4C4C4) //边框色
        static let separatorColor: UIColor = colorWithHex(RGB: 0xEEEEEE) //分割线
        static let backgroundColor: UIColor = colorWithHex(RGB: 0xF8F8F8)
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
