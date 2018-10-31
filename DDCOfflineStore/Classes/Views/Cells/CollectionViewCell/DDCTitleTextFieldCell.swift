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
    static let kTextFieldViewHeight: CGFloat = 45.0

    public lazy var titleLabel: DDCContractLabel = {
        let titleLabel : DDCContractLabel = DDCContractLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = DDCColor.fontColor.black
        return titleLabel
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
    
    func configureCell(model : DDCContractInfoViewModel, indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.textFieldView.type = .labelButton
            self.textFieldView.button!.setTitle("获取用户信息", for: .normal)
        } else {
            self.textFieldView.type = .normal
        }
        self.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.placeholder!, isShowTips:model.isRequired!)
        self.textFieldView.textField!.placeholder = model.placeholder
        self.textFieldView.textField?.text = model.text
        self.textFieldView.textField?.tag = indexPath.row
    }
}
