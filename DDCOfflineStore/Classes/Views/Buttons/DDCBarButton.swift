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
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = DDCColor.mainColor.orange
        self.layer.cornerRadius = 20
        self.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.isUserInteractionEnabled = true
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
            self.backgroundColor = DDCColor.mainColor.orange
            break
        case .forbidden:
            self.backgroundColor = DDCColor.fontColor.gray
            break
        }
    }
}
