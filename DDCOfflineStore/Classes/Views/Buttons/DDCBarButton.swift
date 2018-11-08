//
//  DDCBarButton.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/12.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCBarButton : UIButton {
    enum DDCBarButtonStatus : UInt{
        case normal
        case highlighted
        case forbidden
    }
    
    var handler : (()->Void)?
    var style: DDCBarButtonStatus?
    
    convenience init(title: String, style: DDCBarButtonStatus, handler : (()->Void)?) {
        self.init(frame: CGRect.zero)
        self.setTitle(title, for: .normal)
        self.handler = handler
        self.setStyle(style: style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DDCColor.mainColor.black
        self.layer.cornerRadius = 20
        self.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.isUserInteractionEnabled = true
        self.layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickAction(sender: UIButton) {
        self.handler!()
    }
    
    func setStyle(style: DDCBarButtonStatus) {
        switch style {
        case .normal:
            self.backgroundColor = DDCColor.complementaryColor.borderColor
            self.layer.borderColor = DDCColor.complementaryColor.borderColor.cgColor
            self.setTitleColor(UIColor.white, for: .normal)
            break
        case .highlighted:
            self.backgroundColor = DDCColor.mainColor.black
            self.layer.borderColor = DDCColor.mainColor.black.cgColor
            self.setTitleColor(UIColor.white, for: .normal)
            break
        case .forbidden:
            self.backgroundColor = UIColor.white
            self.layer.borderColor = DDCColor.complementaryColor.borderColor.cgColor
            self.setTitleColor(DDCColor.fontColor.black, for: .normal)
            break
        }
    }
}
