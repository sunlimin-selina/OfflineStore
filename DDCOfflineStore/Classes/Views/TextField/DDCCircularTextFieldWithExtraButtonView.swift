//
//  DDCCircularTextFieldWithExtraButtonView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCircularTextFieldWithExtraButtonView : DDCCircularTextFieldView {
    lazy var extraButton : CountButton? = {
        var _extraButton = CountButton()
        _extraButton.contentHorizontalAlignment = .right
        _extraButton.titleLabel!.font = UIFont.systemFont(ofSize: 10.0)
        _extraButton.setTitle("获取验证码", for: .normal)
        _extraButton.setTitleColor(DDCColor.fontColor.gray, for: .normal)
        _extraButton.isHidden = true
        return _extraButton
    }()
    var showExtraButton : Bool? {
        didSet {
            self.button?.isHidden = showExtraButton!
            self.extraButton?.isHidden = !showExtraButton!
        }
    }
    var enabled : Bool? {
        didSet {
            if (self.showExtraButton!) {
                self.button?.isHidden = enabled!
                self.extraButton?.isHidden = enabled!
                self.button!.isEnabled = enabled!
                self.extraButton!.isEnabled = enabled!
            } else {
                self.button?.isHidden = enabled!
                self.extraButton?.isHidden = enabled!
                self.button?.isEnabled = enabled!
                self.extraButton?.isEnabled = enabled!
            }
        }
    }

    init() {
        super.init(frame: CGRect.zero, type: .CircularTextFieldViewTypeLabelButton)
        self.addSubview(self.extraButton!)
        self.updateViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    func updateViewConstraints() {
        self.extraButton?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView!)
            make.right.equalTo((self.contentView?.snp_rightMargin)!).offset(-14.0)
            make.width.equalTo(70.0)
        })
        
    }
}
