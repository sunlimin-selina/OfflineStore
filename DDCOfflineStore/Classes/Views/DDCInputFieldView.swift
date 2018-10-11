//
//  DDCInputFieldView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCInputFieldView: DDCCircularTextFieldView, CountButtonDelegate {
    
    lazy var firstTextFieldView : DDCCircularTextFieldWithExtraButtonView? = {
        var _firstTextFieldView = DDCCircularTextFieldWithExtraButtonView()
        _firstTextFieldView.textField!.placeholder = "请输入用户名 "
        _firstTextFieldView.button!.delegate = self
        _firstTextFieldView.extraButton!.delegate = self
        return _firstTextFieldView
    }()
    
    var secondTextFieldView : DDCCircularTextFieldView? = {
        var _secondTextFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero, type: .CircularTextFieldViewTypeImageButton)
        _secondTextFieldView.textField!.placeholder = "请输入密码"
        _secondTextFieldView.textField!.isSecureTextEntry = true
        _secondTextFieldView.button?.addTarget(_secondTextFieldView, action: #selector(needSecureText(sender:)), for: .touchUpInside)
        return _secondTextFieldView
    }()
    
    var bottomHidden : Bool?
    var delegate : InputFieldViewDelegate?
    
    override init(frame: CGRect, type: CircularTextFieldViewType) {
        super.init(frame: frame, type: .CircularTextFieldViewTypeNormal)
        self.addSubview(self.firstTextFieldView!)
        self.addSubview(self.secondTextFieldView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func countButton(button: CountButton, isFinished: Bool) {
        if isFinished,
            self.firstTextFieldView!.textField!.text != nil,
            DDCTools.isPhoneNumber(number: self.firstTextFieldView!.textField!.text!) {
            button.setTitleColor(UIColor.init(hex: "#FF5D31"), for: .normal)
            button.isEnabled = true
        }
    }
    
    @objc func needSecureText(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.secondTextFieldView!.textField!.isSecureTextEntry = !sender.isSelected
    }
}

protocol InputFieldViewDelegate {
    
}

