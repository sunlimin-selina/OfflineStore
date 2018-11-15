//
//  DDCCheckBoxWithTitleCollectionCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCheckBoxWithTitleCollectionCell: DDCCheckBoxCollectionViewCell {
    public lazy var label: DDCContractLabel = {
        let _label: DDCContractLabel = DDCContractLabel()
        return _label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.checkBox.button.setImage(UIImage.init(named: "icon_selection_desselected"), for: .normal)
        self.checkBox.button.setImage(UIImage.init(named: "icon_selection_selected"), for: .selected)
        self.addSubview(self.label)
        self.setupContentViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentViewConstraints() {
        let kPadding: CGFloat = 5.0
        self.label.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.equalTo(self).offset(kPadding)
            make.height.equalTo(30.0)
        })
        
        self.checkBox.snp.remakeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.equalTo(self.contentView).offset(kPadding)
            make.top.equalTo(self.label)
            make.height.equalTo(30.0)
        })
    }
    
    override func updateViewConstraints() {
        let kMargin: CGFloat = 65.0
        
        self.subContentView.snp.remakeConstraints({ (make) in
            make.top.equalTo(self.contentView).offset(kMargin)
            make.left.right.bottom.equalTo(self.contentView)
        })
        
        let moduleHeight: Int = 40
        
        for idx in 0...(self.buttons.count - 1) {
            let topMargin: CGFloat = CGFloat(5 * idx + moduleHeight * idx)
            let button: DDCCheckBox = self.buttons[idx]
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(topMargin);
                make.height.equalTo(moduleHeight)
                make.right.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset(kMargin)
            })
        }
    }
    
}
