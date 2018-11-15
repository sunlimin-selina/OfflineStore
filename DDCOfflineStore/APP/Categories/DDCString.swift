//
//  DDCString.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/26.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCString: NSObject {
    class func height(string: String, font: UIFont, width: CGFloat) -> CGFloat {
        let textFont: UIFont = font
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributeString: NSMutableAttributedString = NSMutableAttributedString.init(string: string)
        attributeString.addAttributes([NSAttributedString.Key.font: textFont,NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributeString.length))
        
        let size: CGRect = attributeString.boundingRect(with: CGSize.init(width: width, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine], context: nil)
        
        return size.height
    }
    
    class func width(string: String, font: UIFont, height: CGFloat) -> CGFloat {
        let textFont: UIFont = font
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributeString: NSMutableAttributedString = NSMutableAttributedString.init(string: string)
        attributeString.addAttributes([NSAttributedString.Key.font: textFont,NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributeString.length))
        
        let size: CGRect = attributeString.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:height), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine], context: nil)
        
        return size.width
    }
}
