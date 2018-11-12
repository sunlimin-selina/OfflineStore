//
//  DDCRadioButtonCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCRadioButtonCollectionViewCell: UICollectionViewCell {
    
    var identifier: String?
    
    public lazy var checkBox: DDCRadioWithImageView = {
        let _checkBox: DDCRadioWithImageView = DDCRadioWithImageView()
        _checkBox.isUserInteractionEnabled = false
        return _checkBox
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.checkBox)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.checkBox.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.bottom.equalTo(self.contentView)
        })
        
    }
    
    func configureCell(model: DDCCheckBoxModel) {
        self.checkBox.button.setTitle(model.title, for: .normal)
        self.checkBox.button.isSelected = model.isSelected!
    }
}
