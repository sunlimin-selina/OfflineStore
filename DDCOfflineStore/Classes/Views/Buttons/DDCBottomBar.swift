//
//  DDCBottomBar.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCBottomBar: UIView {
    var buttonArray: Array<UIButton>? = Array()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = DDCColor.complementaryColor.separatorColor.cgColor
        self.layer.borderWidth = 1.0
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButton(button: DDCBarButton) {
        self.addSubview(button)
        self.buttonArray?.append(button)
        self.updateViewConstraints()
    }
    
    func updateViewConstraints() {
        let kButtonWidth: CGFloat = 400.0
        let kButtonHeight: CGFloat = 40.0
        let edgeSpace: UIEdgeInsets = UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        let kLineSpace: CGFloat = 10.0
        var lastBtn: DDCBarButton?
        
        //只有一个的时候居中
        if self.buttonArray!.count == 1 {
            let button: DDCBarButton  = self.buttonArray![0] as! DDCBarButton
            button.snp.makeConstraints({ (make) in
                make.width.equalTo(kButtonWidth)
                make.centerX.centerY.equalTo(self)
                make.height.equalTo(kButtonHeight)
            })
        } else {
            let buttonWidth: CGFloat = (screen.width - edgeSpace.left - edgeSpace.right - CGFloat((self.buttonArray?.count)!) * kLineSpace) / CGFloat(self.buttonArray!.count)
            let count = (self.buttonArray?.count)! - 1
            
            for index in 0...count{
                let button: DDCBarButton  = self.buttonArray![index] as! DDCBarButton
                if index == 0 {
                    button.snp.remakeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.height.equalTo(kButtonHeight)
                        make.left.equalTo(self).offset(edgeSpace.left)
                        make.width.equalTo(buttonWidth)
                    })
                } else {
                    button.snp.makeConstraints({ (make) in
                        make.left.equalTo(lastBtn!.snp_rightMargin).offset(kLineSpace + 15)
                        make.width.equalTo(buttonWidth)
                        make.centerY.equalTo(self)
                        make.height.equalTo(kButtonHeight)
                    })
                }
                lastBtn = button
            }
        }
    }
    
}
