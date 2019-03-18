//
//  DDCContractLabel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCContractLabel: UILabel {
    
    func configure(title: String, isRequired: Bool) {
        if isRequired {
            let dotString: String = title + " • "
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: dotString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)])
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange.init(location: title.count, length: 2))
            self.attributedText = attributedString
        } else {
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.text = title
        }
    }
    
    func configure(title: String, isRequired: Bool, tips: String?, isShowTips: Bool) {
        if isRequired {
            let dotString: String = title + " • "
            if isShowTips {
                let tipsString: String = tips!.count > 0 ? tips!: "请填写\(title)"
                let totalString: String = "\(dotString)(\(tipsString))"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: totalString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)])
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: DDCColor.mainColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], range: NSRange.init(location: title.count + 1, length: totalString.count - title.count - 1))
                self.attributedText = attributedString
            } else {
                let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: dotString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)])
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange.init(location: title.count + 1, length: 1))
                self.attributedText = attributedString
            }
            
        } else {
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.text = title
        }
    }

}
