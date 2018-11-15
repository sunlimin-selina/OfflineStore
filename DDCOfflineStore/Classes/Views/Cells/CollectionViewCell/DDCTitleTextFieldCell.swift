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
        let titleLabel: DDCContractLabel = DDCContractLabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return titleLabel
    }()
    
    public lazy var subtitle: UILabel = {
        let subtitle: UILabel = UILabel()
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
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {

        let kShadowMargin: CGFloat = 5.0
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(kShadowMargin)
        })
        
        self.textFieldView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(DDCAppConfig.width - kShadowMargin * 2)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
        })
        
    }
    
    func configureCell(model: DDCContractInfoViewModel, indexPath: IndexPath, showHint: Bool) {
        let _showHint = showHint
        self.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.tips!, isShowTips:_showHint)
        self.textFieldView.textField.attributedPlaceholder = NSAttributedString.init(string:model.placeholder!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        self.textFieldView.textField.text = model.text
        self.textFieldView.textField.tag = indexPath.row
    }
}
