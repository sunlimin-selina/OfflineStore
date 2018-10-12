//
//  DDCCircularTextFieldView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//


import UIKit
import SnapKit
import Darwin

enum CircularTextFieldViewType : UInt{
    case CircularTextFieldViewTypeNormal
    case CircularTextFieldViewTypeLabelButton
    case CircularTextFieldViewTypeImageButton
}

class DDCCircularTextFieldView: UIView {
    
    lazy var contentView : UIView? = {
        var _contentView = UIView.init()
        _contentView.layer.shadowColor = DDCColor.fontColor.gray.cgColor
        _contentView.layer.shadowRadius = 5.0
        _contentView.layer.shadowOpacity = 0.4
        _contentView.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        _contentView.backgroundColor = UIColor.white
        return _contentView
    }()
    
    lazy var textField : UITextField? = {
        var _textField : UITextField = UITextField.init()
        _textField.autocorrectionType = .no
        _textField.autocapitalizationType = .none
        _textField.clearButtonMode = .always
        _textField.adjustsFontSizeToFitWidth = true
        _textField.keyboardType = .default
        _textField.keyboardAppearance = .default
        _textField.font = UIFont.systemFont(ofSize: 12.0)
        return _textField
    }()
    
    lazy var button : CountButton? = {
        var _button = CountButton.init(frame: CGRect.zero)
        _button.contentHorizontalAlignment = .right
        _button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        _button.setTitle("获取验证码", for: .normal)
        _button.setTitleColor(DDCColor.mainColor.orange, for: .normal)
        return _button
    }()
    
    var cornerRadius : CGFloat? {
        didSet
        {
            self.contentView!.layer.cornerRadius = cornerRadius!
        }
    }
    
    var type : CircularTextFieldViewType {
        get {
            return .CircularTextFieldViewTypeNormal
        }
        set
        {
            switch type {
            case .CircularTextFieldViewTypeNormal:
                do{
                    self.button?.snp.updateConstraints({ (make) in
                        make.width.equalTo(Double.leastNormalMagnitude)
                    })
                }
            case .CircularTextFieldViewTypeImageButton:
                do {
                    self.button?.snp.updateConstraints({ (make) in
                        make.width.equalTo(30.0)
                    })
                    
                    self.button?.setTitle("", for: .normal)
                    self.button?.setImage(UIImage.init(named: "btn_password_nodisplay"), for: .normal)
                    self.button?.setImage(UIImage.init(named: "btn_password_display"), for: .selected)
                }
            case .CircularTextFieldViewTypeLabelButton:
                do {
                    self.button?.snp.updateConstraints({ (make) in
                        make.width.equalTo(70.0)
                    })
                }
            default:
                break
            }
        }
    }
    
    init(frame: CGRect , type: CircularTextFieldViewType) {
        super.init(frame: frame)
        self.addSubview(self.contentView!)
        self.addSubview(self.textField!)
        self.addSubview(self.button!)
        self.setupViewConstraints()
        
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    func setupViewConstraints() {
        self.contentView?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self)
            make.bottom.right.equalTo(self)
        })
        
        self.textField?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView!)
            make.left.equalTo(self.contentView!).offset(14.0)
            make.right.equalTo((self.button?.snp_leftMargin)!)
        })
        
        self.button?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView!)
            make.right.equalTo((self.contentView?.snp_rightMargin)!).offset(-14.0)
            make.width.equalTo(Double.leastNormalMagnitude)
        })
    }
    
    func setPlaceholderWithColor(color:UIColor?,font:UIFont?) {
        if let _ : UIColor = color {
            self.textField?.setValue(color, forKey: "_placeholderLabel.textColor")
        }
        if let _ : UIFont = font {
            self.textField?.setValue(font, forKey: "_placeholderLabel.font")
        }
    }
}
