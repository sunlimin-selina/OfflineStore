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
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: dotString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], range: NSRange.init(title)!)
            self.attributedText = attributedString
        } else {
            self.text = title
        }
    }
    
    func configure(title: String, isRequired: Bool, tips: String, isShowTips: Bool) {
        if isRequired {
            let dotString: String = title + " • "
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: dotString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], range: NSRange.init(location: title.count + 1, length: 1))
            self.attributedText = attributedString
        } else {
            self.text = title
        }
//                var tipsString: String = tips.length ? [NSString stringWithFormat:@"(%@)",tips] : [NSString stringWithFormat:@"(请填写%@)",title
                //   NSString *tipsStr = tips.length ? [NSString stringWithFormat:@"(%@)",tips] : [NSString stringWithFormat:@"(请填写%@)",title];
//                NSString *totalStr = [NSString stringWithFormat:@"%@%@%@",title,dotStr,tipsStr];
//                NSMutableAttributedString *totalAttriStr = [[NSMutableAttributedString alloc]initWithString:totalStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_REGULAR_16}];
//                NSRange dotRange = [totalStr rangeOfString:dotStr];
//                [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_REGULAR_14} range:dotRange];
//                NSRange tipsRange =[totalStr rangeOfString:tipsStr];
//                [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_LIGHT_14} range:tipsRange];
//                self.attributedText = totalAttriStr;
    }

}
