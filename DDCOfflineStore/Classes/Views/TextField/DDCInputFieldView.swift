//
//  DDCInputFieldView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCInputFieldView: UIView, CountButtonDelegate {
    
    lazy var firstTextFieldView: DDCCircularTextFieldWithExtraButtonView? = {
        var _firstTextFieldView = DDCCircularTextFieldWithExtraButtonView()
        _firstTextFieldView.textField.placeholder = "请输入用户名 "
        _firstTextFieldView.button.delegate = self
        _firstTextFieldView.extraButton!.delegate = self
        return _firstTextFieldView
    }()
    
    var secondTextFieldView: DDCCircularTextFieldView? = {
        var _secondTextFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero, type: .imageButton)
        _secondTextFieldView.textField.placeholder = "请输入密码"
        _secondTextFieldView.textField.isSecureTextEntry = true
        _secondTextFieldView.button.addTarget(_secondTextFieldView, action: #selector(needSecureText(sender:)), for: .touchUpInside)
        return _secondTextFieldView
    }()
    
    var bottomHidden: Bool?
    var delegate: InputFieldViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.firstTextFieldView!)
        self.addSubview(self.secondTextFieldView!)
        self.updateViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func countButton(button: CountButton, isFinished: Bool) {
        if isFinished,
            self.firstTextFieldView!.textField.text != nil,
            DDCTools.isPhoneNumber(number: self.firstTextFieldView!.textField.text!) {
            button.setTitleColor(DDCColor.mainColor.red, for: .normal)
            button.isEnabled = true
        }
    }
    
    @objc func needSecureText(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.secondTextFieldView!.textField.isSecureTextEntry = !sender.isSelected
    }
    
    func updateViewConstraints() {
        let kWidth: CGFloat = 424.0
        let kHeight: CGFloat = 145.0 * 0.3
        let kTextFieldMargin = (screen.width - kWidth) / 2
        
        self.firstTextFieldView!.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10.0)
            make.height.equalTo(self).multipliedBy(0.3)
            make.left.equalTo(self).offset(kTextFieldMargin)
            make.right.equalTo(self).offset(-kTextFieldMargin)
            make.centerX.equalTo(self)
        }
        
        self.secondTextFieldView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.firstTextFieldView!.snp_bottomMargin).offset(20.0)
            make.height.equalTo(self).multipliedBy(0.3)
            make.left.equalTo(self).offset(kTextFieldMargin)
            make.right.equalTo(self).offset(-kTextFieldMargin)
            make.centerX.equalTo(self)
        }
        
        self.firstTextFieldView!.cornerRadius = kHeight / 2
        self.secondTextFieldView!.cornerRadius = kHeight / 2
    }
}

protocol InputFieldViewDelegate {
    func inputFieldView(view: DDCInputFieldView, quickLogin: Bool)
}

