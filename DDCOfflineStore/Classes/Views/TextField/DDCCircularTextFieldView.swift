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
    case normal
    case labelButton
    case imageButton
}

class DDCCircularTextFieldView: UIView {
    
    lazy var contentView : UIView = {
        var _contentView = UIView.init()
        _contentView.layer.shadowColor = DDCColor.fontColor.gray.cgColor
        _contentView.layer.shadowRadius = 5.0
        _contentView.layer.shadowOpacity = 0.4
        _contentView.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        _contentView.backgroundColor = UIColor.white
        return _contentView
    }()
    
    lazy var textField : UITextField = {
        var _textField : UITextField = UITextField.init()
        _textField.autocorrectionType = .no
        _textField.autocapitalizationType = .none
        _textField.clearButtonMode = .always
        _textField.adjustsFontSizeToFitWidth = true
        _textField.keyboardType = .default
        _textField.keyboardAppearance = .default
        _textField.font = UIFont.systemFont(ofSize: 20.0)
        return _textField
    }()
    
    lazy var button : CountButton = {
        var _button = CountButton.init(frame: CGRect.zero)
        _button.contentHorizontalAlignment = .right
        _button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        _button.setTitleColor(DDCColor.mainColor.red, for: .normal)
        return _button
    }()
    
    var cornerRadius : CGFloat? {
        didSet
        {
            self.contentView.layer.cornerRadius = cornerRadius!
        }
    }
    
    var type : CircularTextFieldViewType? {
        didSet{
            switch type {
            case .normal?:
                do{
                    self.button.snp.updateConstraints({ (make) in
                        make.width.equalTo(Double.leastNormalMagnitude)
                    })
                }
            case .imageButton?:
                do {
                    self.button.snp.updateConstraints({ (make) in
                        make.width.equalTo(30.0)
                    })
                    
                    self.button.setTitle("", for: .normal)
                    self.button.setImage(UIImage.init(named: "btn_password_nodisplay"), for: .normal)
                    self.button.setImage(UIImage.init(named: "btn_password_display"), for: .selected)
                }
            case .labelButton?:
                do {
                    self.button.snp.updateConstraints({ (make) in
                        make.width.equalTo(150.0)
                    })
                }
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.addSubview(self.textField)
        self.addSubview(self.button)
        self.setupViewConstraints()
        self.type = .normal
    }
    
    convenience init(frame: CGRect , type: CircularTextFieldViewType) {
        self.init(frame: frame)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    func setupViewConstraints() {
        self.contentView.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self)
            make.bottom.right.equalTo(self)
        })
        
        self.textField.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(14.0)
            make.right.equalTo(self.button.snp_leftMargin)
        })
        
        self.button.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView.snp_rightMargin).offset(-14.0)
            make.width.equalTo(Double.leastNormalMagnitude)
        })
    }
    
    @objc func setPlaceholderWithColor(color:UIColor?,font:UIFont?) {
        if let _color = color {
            self.textField.setValue(_color, forKey: "_placeholderLabel.textColor")
        }
        if let _font = font {
            self.textField.setValue(_font, forKey: "_placeholderLabel.font")
        }
    }
}
