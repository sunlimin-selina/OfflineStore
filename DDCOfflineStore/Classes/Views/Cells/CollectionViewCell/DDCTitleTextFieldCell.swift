//
//  DDCTitleTextFieldCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/26.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCTitleTextFieldCell: UICollectionViewCell {
    static let kTextFieldViewHeight: CGFloat = 50.0

    public lazy var titleLabel: DDCContractLabel = {
        let titleLabel : DDCContractLabel = DDCContractLabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return titleLabel
    }()
    
    public lazy var subtitle: UILabel = {
        let subtitle : UILabel = UILabel()
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return subtitle
    }()
    
    public lazy var textFieldView: DDCCircularTextFieldView = {
        let _textFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero)
        _textFieldView.cornerRadius = DDCTitleTextFieldCell.kTextFieldViewHeight / 2
        return _textFieldView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textFieldView)
        self.setupViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self.contentView)
        })
        
        self.textFieldView.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.contentView)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
        })
        
    }
    
    func configureCell(model : DDCContractInfoViewModel, indexPath: IndexPath, showHint: Bool) {
        var _showHint = showHint
        self.subtitle.removeFromSuperview()
        self.textFieldView.textField.isUserInteractionEnabled = true
        self.textFieldView.textField.clearButtonMode = .always
        self.textFieldView.type = .normal

        if indexPath.item == 0 {
            _showHint = true
            self.textFieldView.type = .labelButton
            self.textFieldView.button.setTitle("获取用户信息", for: .normal)
        } else if (indexPath.item == 1 && model.text!.count > 0) {
            self.textFieldView.type = .labelButton
            self.subtitle.text = "会员"//model.descriptions
            self.textFieldView.addSubview(self.subtitle)
            self.textFieldView.button.isHidden = true
            self.subtitle.snp.makeConstraints { (make) in
                make.left.equalTo(self.textFieldView.textField.snp_rightMargin)
                make.right.top.bottom.equalTo(self.textFieldView)
                make.width.equalTo(60)
            }
        } else if (indexPath.item == 10 && model.title == "介绍会员电话") {
            self.textFieldView.type = .labelButton
            self.textFieldView.button.setTitle("会员验证", for: .normal)
        } else if (indexPath.item == 4) {
            // 不让用户手动改年龄
            self.textFieldView.textField.isUserInteractionEnabled = false
            self.textFieldView.textField.clearButtonMode = .never
        } else if (indexPath.item == 11 && model.title == "介绍会员姓名") || (indexPath.item == 12) || (indexPath.item == 10 && model.title == "责任销售") {
            self.textFieldView.textField.isUserInteractionEnabled = false
            self.textFieldView.textField.clearButtonMode = .never
        }
        else {
            self.textFieldView.type = .normal
        }
        self.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.tips!, isShowTips:_showHint)
        self.textFieldView.textField.attributedPlaceholder = NSAttributedString.init(string:model.placeholder!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        self.textFieldView.textField.text = model.text
        self.textFieldView.textField.tag = indexPath.row
    }
}
